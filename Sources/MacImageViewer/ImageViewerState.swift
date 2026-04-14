import AppKit
import Foundation
import MacImageViewerCore
import UniformTypeIdentifiers

/// 界面状态中心：负责打开图片、切换图片、记录当前缩放模式。
/// 这样界面只负责展示，文件扫描和图片加载都集中在这里。
final class ImageViewerState: ObservableObject {
    @Published private(set) var navigator = ImageFileNavigator()
    @Published private(set) var image: NSImage?
    @Published private(set) var errorMessage: String?
    @Published var resetToken = UUID()
    @Published var scaleText = "适合窗口"

    var currentFileName: String {
        navigator.currentURL?.lastPathComponent ?? "未打开图片"
    }

    var statusText: String {
        guard let image else {
            return errorMessage ?? "点击“打开”选择一张图片"
        }

        let width = Int(image.size.width.rounded())
        let height = Int(image.size.height.rounded())
        return "\(navigator.displayPosition) · \(currentFileName) · \(width) × \(height)"
    }

    func openImage() {
        let panel = NSOpenPanel()
        panel.title = "选择图片"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = ImageFileNavigator.supportedExtensions.compactMap {
            UTType(filenameExtension: $0)
        }

        if panel.runModal() == .OK, let url = panel.url {
            open(url)
        }
    }

    func open(_ url: URL) {
        navigator = ImageFileNavigator.navigator(opening: url)
        loadCurrentImageAndResetView()
    }

    func previousImage() {
        navigator = navigator.previous()
        loadCurrentImageAndResetView()
    }

    func nextImage() {
        navigator = navigator.next()
        loadCurrentImageAndResetView()
    }

    func fitToWindow() {
        scaleText = "适合窗口"
        resetToken = UUID()
    }

    func actualSize() {
        scaleText = "100%"
        NotificationCenter.default.post(name: .imageViewerActualSize, object: nil)
    }

    func updateScale(_ scale: CGFloat) {
        if abs(scale - 1) < 0.01 {
            scaleText = "适合窗口"
        } else {
            scaleText = "\(Int((scale * 100).rounded()))%"
        }
    }

    private func loadCurrentImageAndResetView() {
        guard let url = navigator.currentURL else {
            image = nil
            errorMessage = "还没有可显示的图片"
            return
        }

        guard let loadedImage = NSImage(contentsOf: url) else {
            image = nil
            errorMessage = "无法打开这张图片：\(url.lastPathComponent)"
            return
        }

        image = loadedImage
        errorMessage = nil
        fitToWindow()
    }
}

extension Notification.Name {
    static let imageViewerActualSize = Notification.Name("imageViewerActualSize")
}
