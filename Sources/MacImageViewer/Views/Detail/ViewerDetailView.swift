import AppKit
import SwiftUI

struct ViewerDetailView: View {
    @ObservedObject var state: ImageViewerState

    var body: some View {
        VStack(spacing: 0) {
            ViewerToolbarView(state: state)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            ViewerStatusBarView(state: state)
        }
        .background(
            LinearGradient(
                colors: [
                    ViewerTheme.detailBaseTop,
                    ViewerTheme.detailBaseBottom
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private var content: some View {
        ZStack {
            ViewerBackgroundView()

            Circle()
                .fill(ViewerTheme.detailHeroGlow)
                .frame(width: 420, height: 420)
                .blur(radius: 24)
                .offset(x: 260, y: -180)

            LinearGradient(
                colors: [
                    ViewerTheme.detailCanvasTop,
                    ViewerTheme.detailCanvasBottom
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            if let image = state.image {
                ViewerPanel {
                    ImageCanvasView(
                        image: image,
                        resetToken: state.resetToken,
                        onPrevious: state.previousImage,
                        onNext: state.nextImage,
                        onScaleChanged: state.updateScale
                    )
                    .contextMenu {
                        imageContextMenu
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                }
                .padding(22)
            } else {
                EmptyStateView(
                    title: "打开一张图片开始浏览",
                    message: state.errorMessage ?? "左边浏览列表，右边沉浸看图。像一个更轻、更快的 macOS 原生看片夹。",
                    actionTitle: "打开图片",
                    action: state.openImage
                )
                .padding(32)
            }
        }
    }

    @ViewBuilder
    private var imageContextMenu: some View {
        Button("复制图片") {
            state.copyCurrentImage()
        }

        Button("粘贴到当前文件夹") {
            state.pasteImageIntoCurrentFolder()
        }
        .disabled(!state.canPasteImageFromPasteboard)

        Button("复制文件路径") {
            state.copyCurrentImagePath()
        }

        Divider()

        Button("向左旋转") {
            state.rotateLeft()
        }

        Button("向右旋转") {
            state.rotateRight()
        }

        Divider()

        Button("在 Finder 中显示") {
            state.revealCurrentImageInFinder()
        }

        Button("移到废纸篓") {
            state.deleteCurrentImageToTrash()
        }
    }
}

private struct ViewerBackgroundView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .sidebar
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
