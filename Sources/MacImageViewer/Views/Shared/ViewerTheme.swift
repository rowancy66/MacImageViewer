import AppKit
import SwiftUI

enum ViewerTheme {
    static let shellTop = Color(red: 0.98, green: 0.96, blue: 0.92)
    static let shellMiddle = Color(red: 0.92, green: 0.92, blue: 0.88)
    static let shellBottom = Color(red: 0.83, green: 0.87, blue: 0.84)
    static let shellGlowWarm = Color(red: 0.98, green: 0.80, blue: 0.65).opacity(0.36)
    static let shellGlowCool = Color(red: 0.71, green: 0.82, blue: 0.81).opacity(0.34)
    static let shellStroke = Color.white.opacity(0.56)

    static let sidebarBase = Color(red: 0.97, green: 0.95, blue: 0.90)
    static let sidebarCard = Color.white.opacity(0.74)
    static let sidebarCardStrong = Color.white.opacity(0.92)
    static let sidebarAccent = Color(red: 0.42, green: 0.57, blue: 0.64)
    static let sidebarWarmAccent = Color(red: 0.82, green: 0.62, blue: 0.42)
    static let sidebarBorder = Color.black.opacity(0.08)
    static let sidebarSelection = Color(red: 0.44, green: 0.57, blue: 0.66)
    static let sidebarSelectionGlow = Color(red: 0.80, green: 0.89, blue: 0.91)
    static let sidebarHover = Color.white.opacity(0.92)
    static let sidebarRow = Color.white.opacity(0.68)
    static let sidebarRowText = Color.black.opacity(0.80)
    static let sidebarRowSecondary = Color.black.opacity(0.48)

    static let detailBaseTop = Color(red: 0.97, green: 0.97, blue: 0.95)
    static let detailBaseBottom = Color(red: 0.88, green: 0.91, blue: 0.90)
    static let detailHeroGlow = Color(red: 0.97, green: 0.83, blue: 0.70).opacity(0.34)
    static let detailCanvasTop = Color(red: 0.95, green: 0.96, blue: 0.94)
    static let detailCanvasBottom = Color(red: 0.84, green: 0.88, blue: 0.88)
    static let detailPanel = Color.white.opacity(0.66)
    static let detailPanelStrong = Color.white.opacity(0.92)
    static let detailBorder = Color.black.opacity(0.08)
    static let detailText = Color.black.opacity(0.84)
    static let detailTextMuted = Color.black.opacity(0.63)
    static let detailTextSoft = Color.black.opacity(0.46)

    static let actionPrimary = Color(red: 0.39, green: 0.56, blue: 0.66)
    static let actionPrimaryPressed = Color(red: 0.31, green: 0.46, blue: 0.55)
    static let accentWarm = Color(red: 0.90, green: 0.67, blue: 0.45)
    static let accentSoft = Color(red: 0.88, green: 0.91, blue: 0.89)
}

struct ViewerCapsuleButtonStyle: ButtonStyle {
    var highlighted: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .foregroundStyle(highlighted ? Color.white : ViewerTheme.detailTextMuted)
            .clipShape(Capsule(style: .continuous))
            .overlay(
                Capsule(style: .continuous)
                    .stroke(highlighted ? Color.clear : ViewerTheme.detailBorder, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .shadow(
                color: highlighted ? ViewerTheme.actionPrimary.opacity(configuration.isPressed ? 0.08 : 0.18) : .clear,
                radius: highlighted ? 10 : 0,
                x: 0,
                y: highlighted ? 6 : 0
            )
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }

    private func backgroundColor(isPressed: Bool) -> Color {
        if highlighted {
            return isPressed ? ViewerTheme.actionPrimaryPressed : ViewerTheme.actionPrimary
        }

        return isPressed ? ViewerTheme.detailPanelStrong : ViewerTheme.detailPanel
    }
}

struct ViewerPanel<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(
                LinearGradient(
                    colors: [
                        ViewerTheme.detailPanelStrong.opacity(0.92),
                        ViewerTheme.detailPanel
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(ViewerTheme.detailBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.06), radius: 14, x: 0, y: 8)
    }
}
