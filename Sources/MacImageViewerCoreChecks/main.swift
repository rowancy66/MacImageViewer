import Foundation
import MacImageViewerCore

enum CheckFailure: Error, CustomStringConvertible {
    case failed(String)

    var description: String {
        switch self {
        case .failed(let message):
            return message
        }
    }
}

func expect(_ condition: @autoclosure () -> Bool, _ message: String) throws {
    if !condition() {
        throw CheckFailure.failed(message)
    }
}

func checkSupportedImageExtensionsAreCaseInsensitive() throws {
    try expect(ImageFileNavigator.isSupportedImage(URL(fileURLWithPath: "/tmp/a.JPG")), "JPG 应被识别为图片")
    try expect(ImageFileNavigator.isSupportedImage(URL(fileURLWithPath: "/tmp/a.webp")), "webp 应被识别为图片")
    try expect(ImageFileNavigator.isSupportedImage(URL(fileURLWithPath: "/tmp/a.HEIC")), "HEIC 应被识别为图片")
    try expect(!ImageFileNavigator.isSupportedImage(URL(fileURLWithPath: "/tmp/a.pdf")), "PDF 不应被识别为图片")
}

func checkImageFilesFiltersAndSortsByFinderLikeNameOrder() throws {
    let folder = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: folder) }

    try Data().write(to: folder.appendingPathComponent("image10.png"))
    try Data().write(to: folder.appendingPathComponent("image2.jpg"))
    try Data().write(to: folder.appendingPathComponent("notes.txt"))
    try Data().write(to: folder.appendingPathComponent("image1.webp"))

    let names = ImageFileNavigator.imageFiles(in: folder).map(\.lastPathComponent)
    try expect(names == ["image1.webp", "image2.jpg", "image10.png"], "图片列表过滤或排序不正确：\(names)")
}

func checkNextAndPreviousWrapAroundAtEdges() throws {
    let files = [
        URL(fileURLWithPath: "/tmp/1.png"),
        URL(fileURLWithPath: "/tmp/2.png"),
        URL(fileURLWithPath: "/tmp/3.png")
    ]

    let first = ImageFileNavigator(files: files, currentIndex: 0)
    try expect(first.previous().currentURL?.lastPathComponent == "3.png", "第一张的上一张应循环到最后一张")
    try expect(first.next().currentURL?.lastPathComponent == "2.png", "第一张的下一张应是第二张")

    let last = ImageFileNavigator(files: files, currentIndex: 2)
    try expect(last.next().currentURL?.lastPathComponent == "1.png", "最后一张的下一张应循环到第一张")
}

let checks: [(String, () throws -> Void)] = [
    ("支持的图片扩展名不区分大小写", checkSupportedImageExtensionsAreCaseInsensitive),
    ("扫描文件夹时只保留图片并按 Finder 风格排序", checkImageFilesFiltersAndSortsByFinderLikeNameOrder),
    ("上一张和下一张在边界处循环", checkNextAndPreviousWrapAroundAtEdges)
]

do {
    for (name, check) in checks {
        try check()
        print("PASS: \(name)")
    }
    print("全部核心逻辑自检通过")
} catch {
    fputs("FAIL: \(error)\n", stderr)
    exit(1)
}
