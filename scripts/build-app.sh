#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="LiteViewer"
DIST_DIR="$ROOT_DIR/dist"
RELEASE_DIR="$DIST_DIR/release"
APP_DIR="$DIST_DIR/$APP_NAME.app"
DMG_ROOT_DIR="$DIST_DIR/dmg-root"
DMG_PATH="$DIST_DIR/$APP_NAME.dmg"
LEGACY_APP_DIR="$DIST_DIR/MacImageViewer.app"
LEGACY_DMG_PATH="$DIST_DIR/MacImageViewer.dmg"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"
ICON_SCRIPT_HOME="/tmp/liteviewer-icon-home"
ICON_MODULE_CACHE="/tmp/liteviewer-icon-module-cache"
ICON_CLANG_CACHE="/tmp/liteviewer-icon-clang-cache"
SWIFTPM_HOME="/tmp/liteviewer-swiftpm-home"
SWIFTPM_MODULE_CACHE="/tmp/liteviewer-swiftpm-module-cache"
SWIFTPM_CLANG_CACHE="/tmp/liteviewer-swiftpm-clang-cache"

cd "$ROOT_DIR"

VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" packaging/Info.plist)
BUILD_NUMBER=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" packaging/Info.plist)
VERSIONED_DMG_PATH="$RELEASE_DIR/$APP_NAME-$VERSION.dmg"
ZIP_PATH="$RELEASE_DIR/$APP_NAME-$VERSION.app.zip"
CHECKSUM_PATH="$RELEASE_DIR/$APP_NAME-$VERSION-checksums.txt"
RELEASE_NOTES_PATH="$RELEASE_DIR/$APP_NAME-$VERSION-release-notes.txt"

mkdir -p "$ICON_SCRIPT_HOME" "$ICON_MODULE_CACHE" "$ICON_CLANG_CACHE"
mkdir -p \
  "$SWIFTPM_HOME/Library/Caches/org.swift.swiftpm" \
  "$SWIFTPM_HOME/Library/org.swift.swiftpm/configuration" \
  "$SWIFTPM_HOME/Library/org.swift.swiftpm/security" \
  "$SWIFTPM_MODULE_CACHE" \
  "$SWIFTPM_CLANG_CACHE"

HOME="$ICON_SCRIPT_HOME" \
SWIFTPM_MODULECACHE_OVERRIDE="$ICON_MODULE_CACHE" \
CLANG_MODULE_CACHE_PATH="$ICON_CLANG_CACHE" \
swift scripts/generate-app-icon.swift
HOME="$SWIFTPM_HOME" \
SWIFTPM_MODULECACHE_OVERRIDE="$SWIFTPM_MODULE_CACHE" \
CLANG_MODULE_CACHE_PATH="$SWIFTPM_CLANG_CACHE" \
swift build -c release --product "$APP_NAME"

rm -rf "$APP_DIR" "$DMG_ROOT_DIR" "$LEGACY_APP_DIR" "$RELEASE_DIR"
rm -f "$DMG_PATH" "$LEGACY_DMG_PATH"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR" "$RELEASE_DIR"

cp ".build/release/$APP_NAME" "$MACOS_DIR/$APP_NAME"
cp "packaging/Info.plist" "$CONTENTS_DIR/Info.plist"
cp "packaging/AppIcon.icns" "$RESOURCES_DIR/AppIcon.icns"
printf 'APPL????' > "$CONTENTS_DIR/PkgInfo"
chmod +x "$MACOS_DIR/$APP_NAME"

# 清理下载隔离属性，避免刚打包出来的 App 在 Finder 里被额外拦一下。
if command -v xattr >/dev/null 2>&1; then
  xattr -dr com.apple.quarantine "$APP_DIR" >/dev/null 2>&1 || true
fi

# 注册到 LaunchServices，方便它出现在“打开方式”列表里。
if command -v /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister >/dev/null 2>&1; then
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
    -f "$APP_DIR" >/dev/null 2>&1 || true
fi

mkdir -p "$DMG_ROOT_DIR"
cp -R "$APP_DIR" "$DMG_ROOT_DIR/$APP_NAME.app"
ln -s /Applications "$DMG_ROOT_DIR/Applications"

hdiutil create \
  -volname "$APP_NAME" \
  -srcfolder "$DMG_ROOT_DIR" \
  -ov \
  -format UDZO \
  "$DMG_PATH"

rm -rf "$DMG_ROOT_DIR"

cp "$DMG_PATH" "$VERSIONED_DMG_PATH"
ditto -c -k --sequesterRsrc --keepParent "$APP_DIR" "$ZIP_PATH"

cat > "$RELEASE_NOTES_PATH" <<EOF
LiteViewer $VERSION
Build: $BUILD_NUMBER

发行内容：
- $APP_NAME-$VERSION.dmg：推荐安装包，双击后拖到 Applications
- $APP_NAME-$VERSION.app.zip：压缩版 App

说明：
- 当前产物适合本地分发和 GitHub Releases 发布
- 如需减少 macOS 安全提示，还需要后续补开发者签名与公证
EOF

{
  shasum -a 256 "$VERSIONED_DMG_PATH"
  shasum -a 256 "$ZIP_PATH"
} > "$CHECKSUM_PATH"

echo "已生成：$APP_DIR"
echo "已生成：$DMG_PATH"
echo "已生成发行目录：$RELEASE_DIR"
echo "版本化 DMG：$VERSIONED_DMG_PATH"
echo "压缩版 App：$ZIP_PATH"
echo "校验文件：$CHECKSUM_PATH"
echo "安装方式：打开 DMG，把 $APP_NAME.app 拖到 Applications。"
