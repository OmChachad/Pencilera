import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.ultraThickMaterial)
            .environment(\.colorScheme, .dark)
            .bold()
            .padding(7.5)
            .frame(minWidth: 150)
            .background(.white.gradient.opacity(0.4))
            .background(.ultraThinMaterial)
            .environment(\.colorScheme, .light)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .hoverEffect(.lift)
            .animation(.default, value: configuration.isPressed)
    }
}
