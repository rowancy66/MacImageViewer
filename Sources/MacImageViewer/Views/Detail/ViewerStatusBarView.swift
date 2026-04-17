import SwiftUI

struct ViewerStatusBarView: View {
    @ObservedObject var state: ImageViewerState

    var body: some View {
        HStack(spacing: 12) {
            statusBadge(symbol: "photo", text: state.statusText)

            Spacer()

            statusBadge(symbol: "scope", text: state.scaleText)

            statusBadge(symbol: "folder", text: state.currentFolderName)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(ViewerTheme.detailPanel.opacity(0.88))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(ViewerTheme.detailBorder)
                .frame(height: 1)
        }
    }

    private func statusBadge(symbol: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: symbol)
            Text(text)
                .lineLimit(1)
        }
        .font(.system(size: 11, weight: .medium))
        .foregroundStyle(ViewerTheme.detailTextMuted)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Color.white.opacity(0.62))
        .clipShape(Capsule(style: .continuous))
    }
}
