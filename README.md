# MacImageViewer

MacImageViewer 是一个轻量的 macOS 原生看图小软件。第一版目标很简单：打开一张图片后，自动浏览同文件夹里的其他图片，并支持触控板缩放和左右滑动切换。

## 功能

- 支持常见图片格式：`jpg`、`jpeg`、`png`、`gif`、`tiff`、`tif`、`bmp`、`heic`、`heif`、`webp`
- 打开单张图片后，自动读取同文件夹内的图片
- 双指捏合放大和缩小
- 双指左右滑动切换上一张 / 下一张
- 键盘左右方向键切换图片
- 支持“适合窗口”和“实际大小”
- 显示当前序号、文件名和图片尺寸

## 运行方法

请先确认 Mac 已安装 Xcode 或 Xcode Command Line Tools。

```bash
cd /Users/cy/Documents/codex/私人/MacImageViewer
swift run MacImageViewer
```

如果系统提示 Swift 工具链不匹配，请打开 Xcode，进入 `Settings -> Locations`，选择当前安装的 Xcode 作为 Command Line Tools。

## 自检方法

项目内置了一个不依赖 XCTest 的核心逻辑自检程序：

```bash
swift run MacImageViewerCoreChecks
```

它会检查：

- 图片格式识别是否正确
- 文件夹扫描是否只保留图片
- 图片列表是否按 Finder 风格排序
- 上一张 / 下一张在边界处是否能循环

## 使用说明

1. 启动软件。
2. 点击“打开”，选择任意一张图片。
3. 软件会自动读取这张图片所在文件夹里的其他图片。
4. 使用触控板双指捏合缩放。
5. 使用触控板左右滑动，或键盘左右方向键切换图片。

## 目录说明

- `Sources/MacImageViewerCore/`：图片格式识别、文件夹扫描、上一张 / 下一张导航等核心逻辑。
- `Sources/MacImageViewer/`：macOS 界面、窗口、按钮、触控板手势和图片绘制。
- `Sources/MacImageViewerCoreChecks/`：最小自检程序。

## 后续可以优化

- 增加缩略图侧栏
- 增加删除、复制路径、在 Finder 中显示
- 增加幻灯片播放
- 增加 GIF 动图完整播放支持
- 打包成 `.app` 或 `.dmg`

## 维护建议

这个项目第一版故意保持简单：核心逻辑和界面逻辑分开，方便以后继续扩展。后续新增功能时，建议先改 `MacImageViewerCore` 并补充自检，再接到界面上。
