#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="MacImageViewer"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

cd "$ROOT_DIR"

swift build -c release --product "$APP_NAME"

rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

cp ".build/release/$APP_NAME" "$MACOS_DIR/$APP_NAME"
cp "packaging/Info.plist" "$CONTENTS_DIR/Info.plist"
chmod +x "$MACOS_DIR/$APP_NAME"

echo "已生成：$APP_DIR"
