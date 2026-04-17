import SwiftUI

struct ViewerToolbarView: View {
    @ObservedObject var state: ImageViewerState

    var body: some View {
        HStack(spacing: 12) {
            ViewerPanel {
                HStack(spacing: 10) {
                    toolbarCaption("文件")

                    Button {
                        state.openImage()
                    } label: {
                        Label("打开图片", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                    }
                    .buttonStyle(ViewerCapsuleButtonStyle(highlighted: true))
                    .keyboardShortcut("o", modifiers: .command)

                    keyboardBadge("⌘O")
                }
                .padding(10)
            }
            .frame(maxWidth: 200)

            ViewerPanel {
                HStack(spacing: 8) {
                    toolbarCaption("浏览")
                    compactButton(symbol: "chevron.left", title: "上一张", action: state.previousImage)
                    compactButton(symbol: "chevron.right", title: "下一张", action: state.nextImage)
                }
                .padding(10)
            }
            .frame(maxWidth: 158)

            ViewerPanel {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        toolbarCaption("当前图片")
                        toolbarInfoBadge(symbol: "folder", text: state.currentFolderName)
                        Spacer(minLength: 8)
                        toolbarInfoBadge(symbol: "scope", text: state.scaleText)
                    }

                    HStack(spacing: 12) {
                        Text(state.currentFileName)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(ViewerTheme.detailText)
                            .lineLimit(1)

                        Spacer(minLength: 10)

                        Text(state.sidebarSummaryText)
                            .font(.system(size: 12))
                            .foregroundStyle(ViewerTheme.detailTextSoft)
                            .lineLimit(1)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }

            ViewerPanel {
                HStack(spacing: 8) {
                    toolbarCaption("视图")
                    textButton("适合", action: state.fitToWindow)
                    textButton("原图", action: state.actualSize)
                    Divider()
                        .frame(height: 18)
                        .overlay(ViewerTheme.detailBorder)
                    toolbarCaption("编辑")
                    compactButton(symbol: "rotate.left", title: "左转", action: state.rotateLeft)
                    compactButton(symbol: "rotate.right", title: "右转", action: state.rotateRight)
                }
                .padding(10)
            }
            .frame(maxWidth: 290)
        }
        .padding(.horizontal, 18)
        .padding(.top, 18)
        .padding(.bottom, 14)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(ViewerTheme.detailBorder)
                .frame(height: 1)
        }
    }

    @ViewBuilder
    private func compactButton(symbol: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 12, weight: .bold))
                .frame(width: 28, height: 28)
        }
        .buttonStyle(ViewerCapsuleButtonStyle())
        .disabled(!state.hasCurrentImage)
        .help(title)
    }

    @ViewBuilder
    private func textButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .buttonStyle(ViewerCapsuleButtonStyle())
            .disabled(!state.hasCurrentImage)
    }

    private func toolbarCaption(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 10, weight: .bold))
            .tracking(0.4)
            .foregroundStyle(ViewerTheme.detailTextSoft)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(ViewerTheme.accentSoft.opacity(0.9))
            .clipShape(Capsule(style: .continuous))
    }

    private func keyboardBadge(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold, design: .rounded))
            .foregroundStyle(ViewerTheme.detailTextMuted)
            .padding(.horizontal, 9)
            .padding(.vertical, 7)
            .background(ViewerTheme.detailPanelStrong)
            .clipShape(Capsule(style: .continuous))
    }

    private func toolbarInfoBadge(symbol: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: symbol)
            Text(text)
                .lineLimit(1)
        }
        .font(.system(size: 11, weight: .medium))
        .foregroundStyle(ViewerTheme.detailTextMuted)
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.7))
        .clipShape(Capsule(style: .continuous))
    }
}
