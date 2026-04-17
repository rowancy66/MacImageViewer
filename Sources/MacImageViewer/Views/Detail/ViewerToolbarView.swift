import SwiftUI

struct ViewerToolbarView: View {
    @ObservedObject var state: ImageViewerState

    var body: some View {
        HStack(spacing: 10) {
            openPanel

            navigationPanel

            Spacer(minLength: 0)

            imageMeta

            Spacer(minLength: 0)

            viewPanel

            rotatePanel
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

    private var openPanel: some View {
        ViewerPanel {
            Button {
                state.openImage()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                    Text("打开")
                }
            }
            .keyboardShortcut("o", modifiers: .command)
            .buttonStyle(ViewerCapsuleButtonStyle(highlighted: true))
            .padding(10)
        }
    }

    private var navigationPanel: some View {
        ViewerPanel {
            HStack(spacing: 6) {
                compactButton(symbol: "chevron.left", title: "上一张", action: state.previousImage)
                compactButton(symbol: "chevron.right", title: "下一张", action: state.nextImage)
            }
            .padding(10)
        }
    }

    private var imageMeta: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(state.currentFileName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(ViewerTheme.detailText)
                .lineLimit(1)

            if state.hasOpenedImages {
                Text(state.sidebarSummaryText)
                    .font(.system(size: 11))
                    .foregroundStyle(ViewerTheme.detailTextSoft)
                    .lineLimit(1)
            }
        }
        .frame(minWidth: 160, idealWidth: 280, maxWidth: 360)
    }

    private var viewPanel: some View {
        ViewerPanel {
            HStack(spacing: 6) {
                textButton("适合", action: state.fitToWindow)
                textButton("原图", action: state.actualSize)
            }
            .padding(10)
        }
    }

    private var rotatePanel: some View {
        ViewerPanel {
            HStack(spacing: 6) {
                compactButton(symbol: "rotate.left", title: "左转", action: state.rotateLeft)
                compactButton(symbol: "rotate.right", title: "右转", action: state.rotateRight)
            }
            .padding(10)
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
}
