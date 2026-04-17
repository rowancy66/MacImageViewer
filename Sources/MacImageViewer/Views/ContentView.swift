import SwiftUI

struct ContentView: View {
    @ObservedObject var state: ImageViewerState

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    ViewerTheme.shellTop,
                    ViewerTheme.shellMiddle,
                    ViewerTheme.shellBottom
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            decorativeBackground

            HSplitView {
                ImageSidebarView(
                    state: state,
                    thumbnailService: state.thumbnailService
                )
                .frame(minWidth: 260, idealWidth: 298, maxWidth: 360)

                ViewerDetailView(state: state)
                    .frame(minWidth: 620, maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.white.opacity(0.14))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(ViewerTheme.shellStroke, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.14), radius: 36, x: 0, y: 18)
            .padding(20)
        }
        .frame(minWidth: 980, minHeight: 660)
    }

    private var decorativeBackground: some View {
        ZStack {
            Circle()
                .fill(ViewerTheme.shellGlowWarm)
                .frame(width: 360, height: 360)
                .blur(radius: 18)
                .offset(x: -360, y: -220)

            Circle()
                .fill(ViewerTheme.shellGlowCool)
                .frame(width: 440, height: 440)
                .blur(radius: 24)
                .offset(x: 360, y: 180)

            RoundedRectangle(cornerRadius: 56, style: .continuous)
                .fill(Color.white.opacity(0.12))
                .frame(width: 380, height: 180)
                .rotationEffect(.degrees(-10))
                .blur(radius: 6)
                .offset(x: 240, y: -260)
        }
        .allowsHitTesting(false)
    }
}
