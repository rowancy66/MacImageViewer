import SwiftUI

struct ImageSidebarView: View {
    @ObservedObject var state: ImageViewerState
    let thumbnailService: ImageThumbnailService

    var body: some View {
        VStack(spacing: 0) {
            headerCard

            if state.sidebarItems.isEmpty {
                sidebarEmptyState
            } else {
                HStack {
                    Text("当前图库")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(ViewerTheme.sidebarRowSecondary)
                        .textCase(.uppercase)
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 4)
                .padding(.bottom, 6)

                ScrollViewReader { proxy in
                    imageList
                        .onAppear {
                            scrollToSelection(with: proxy, animated: false)
                        }
                        .onChange(of: state.selectedSidebarURL) { _ in
                            scrollToSelection(with: proxy, animated: true)
                        }
                }
            }
        }
        .background(
            LinearGradient(
                colors: [
                    ViewerTheme.sidebarBase,
                    ViewerTheme.sidebarBase.opacity(0.92)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("轻巧浏览")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(ViewerTheme.sidebarAccent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(ViewerTheme.sidebarCardStrong)
                    .clipShape(Capsule(style: .continuous))

                Spacer()

                Image(systemName: "circle.grid.2x2")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(ViewerTheme.sidebarWarmAccent)
            }

            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    ViewerTheme.sidebarWarmAccent,
                                    ViewerTheme.sidebarAccent
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.22), lineWidth: 1)
                    Image(systemName: "photo.stack")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 42, height: 42)

                VStack(alignment: .leading, spacing: 3) {
                    Text("LiteViewer")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.black.opacity(0.82))

                    Text("轻量看图浏览器")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.black.opacity(0.46))
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(state.currentFolderName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.black.opacity(0.76))
                    .lineLimit(1)

                Text(state.sidebarSummaryText)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.black.opacity(0.48))
                    .lineLimit(2)
            }

            Button {
                state.openImage()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                    Text("打开图片")
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [
                            ViewerTheme.sidebarWarmAccent,
                            ViewerTheme.sidebarAccent
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule(style: .continuous))
            }

            HStack(spacing: 8) {
                headerMetric(symbol: "folder", text: state.currentFolderName)
                headerMetric(symbol: "photo.on.rectangle", text: state.sidebarSummaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    ViewerTheme.sidebarCardStrong,
                    ViewerTheme.sidebarCard
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(ViewerTheme.sidebarBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 10)
        .padding(.horizontal, 14)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }

    private var imageList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(state.sidebarItems) { item in
                    Button {
                        state.selectImage(item.id)
                    } label: {
                        ImageSidebarRowView(
                            item: item,
                            thumbnailService: thumbnailService,
                            isSelected: state.selectedSidebarURL == item.id
                        )
                    }
                    .buttonStyle(.plain)
                    .id(item.id)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
        }
    }

    private var sidebarEmptyState: some View {
        VStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(ViewerTheme.sidebarCardStrong)
                .frame(width: 126, height: 126)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 6]))
                        .foregroundStyle(ViewerTheme.sidebarAccent.opacity(0.35))
                        .padding(10)
                )
                .overlay(
                    VStack(spacing: 8) {
                        Image(systemName: "photo.stack")
                            .font(.system(size: 28, weight: .light))
                            .foregroundStyle(ViewerTheme.sidebarAccent)
                        Capsule().fill(Color.black.opacity(0.12)).frame(width: 66, height: 6)
                    }
                )

            Text("这里会出现你的图片清单")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.black.opacity(0.72))

            Text("先打开任意一张图，LiteViewer 会自动把同文件夹内容整理到左边。")
                .font(.system(size: 12))
                .foregroundStyle(Color.black.opacity(0.48))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 230)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
    }

    private func headerMetric(symbol: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: symbol)
            Text(text)
                .lineLimit(1)
        }
        .font(.system(size: 11, weight: .medium))
        .foregroundStyle(ViewerTheme.sidebarRowSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Color.white.opacity(0.62))
        .clipShape(Capsule(style: .continuous))
    }

    private func scrollToSelection(with proxy: ScrollViewProxy, animated: Bool) {
        guard let selectedSidebarURL = state.selectedSidebarURL else {
            return
        }

        let scrollAction = {
            proxy.scrollTo(selectedSidebarURL, anchor: .center)
        }

        if animated {
            withAnimation(.spring(response: 0.26, dampingFraction: 0.9)) {
                scrollAction()
            }
        } else {
            scrollAction()
        }
    }
}

private struct ImageSidebarRowView: View {
    let item: ViewerSidebarItem
    let thumbnailService: ImageThumbnailService
    let isSelected: Bool

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 12) {
            SidebarThumbnailView(
                url: item.url,
                thumbnailService: thumbnailService,
                isSelected: isSelected
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.fileName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(isSelected ? Color.white : ViewerTheme.sidebarRowText)
                    .lineLimit(2)

                Text(item.secondaryText)
                    .font(.system(size: 11))
                    .foregroundStyle(isSelected ? Color.white.opacity(0.72) : ViewerTheme.sidebarRowSecondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            Circle()
                .fill(selectionIndicatorColor)
                .frame(width: isSelected ? 8 : 6, height: isSelected ? 8 : 6)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.white.opacity(0.48) : Color.clear, lineWidth: 1)
                )
                .shadow(color: isSelected ? ViewerTheme.sidebarSelectionGlow.opacity(0.55) : .clear, radius: 8)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(backgroundFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(borderColor, lineWidth: isSelected ? 1.2 : 1)
        )
        .overlay(alignment: .leading) {
            Capsule(style: .continuous)
                .fill(isSelected ? ViewerTheme.sidebarSelectionGlow : Color.clear)
                .frame(width: 4, height: isSelected ? 34 : 0)
                .padding(.leading, 6)
        }
        .shadow(color: shadowColor, radius: isSelected ? 16 : 8, x: 0, y: isSelected ? 10 : 4)
        .scaleEffect(isHovered ? 1.01 : 1)
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.16)) {
                isHovered = hovering
            }
        }
        .animation(.spring(response: 0.22, dampingFraction: 0.88), value: isSelected)
    }

    private var backgroundFill: some ShapeStyle {
        if isSelected {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        ViewerTheme.sidebarSelection,
                        ViewerTheme.sidebarSelection.opacity(0.90)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }

        if isHovered {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        ViewerTheme.sidebarHover,
                        Color.white.opacity(0.76)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }

        return AnyShapeStyle(
            LinearGradient(
                colors: [
                    ViewerTheme.sidebarRow,
                    Color.white.opacity(0.52)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    private var borderColor: Color {
        if isSelected {
            return ViewerTheme.sidebarSelectionGlow.opacity(0.62)
        }

        return isHovered ? ViewerTheme.sidebarSelectionGlow.opacity(0.24) : ViewerTheme.sidebarBorder
    }

    private var shadowColor: Color {
        if isSelected {
            return .black.opacity(0.20)
        }

        return isHovered ? .black.opacity(0.10) : .clear
    }

    private var selectionIndicatorColor: Color {
        if isSelected {
            return ViewerTheme.sidebarSelectionGlow
        }

        return isHovered ? ViewerTheme.sidebarAccent.opacity(0.42) : Color.black.opacity(0.12)
    }
}
