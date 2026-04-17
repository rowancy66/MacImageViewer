#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SWIFTPM_HOME="/tmp/liteviewer-swiftpm-home"
SWIFTPM_MODULE_CACHE="/tmp/liteviewer-swiftpm-module-cache"
SWIFTPM_CLANG_CACHE="/tmp/liteviewer-swiftpm-clang-cache"

cd "$ROOT_DIR"

mkdir -p \
  "$SWIFTPM_HOME/Library/Caches/org.swift.swiftpm" \
  "$SWIFTPM_HOME/Library/org.swift.swiftpm/configuration" \
  "$SWIFTPM_HOME/Library/org.swift.swiftpm/security" \
  "$SWIFTPM_MODULE_CACHE" \
  "$SWIFTPM_CLANG_CACHE"

echo "==> 运行核心自检"
HOME="$SWIFTPM_HOME" \
SWIFTPM_MODULECACHE_OVERRIDE="$SWIFTPM_MODULE_CACHE" \
CLANG_MODULE_CACHE_PATH="$SWIFTPM_CLANG_CACHE" \
swift run LiteViewerCoreChecks

echo "==> 构建发行包"
bash scripts/build-app.sh

echo "==> 发行产物已准备完成"
echo "目录：$ROOT_DIR/dist/release"
