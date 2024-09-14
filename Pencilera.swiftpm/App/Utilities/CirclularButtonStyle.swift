import SwiftUI

struct CircularButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .frame(width: 35, height: 35)
            .background(.ultraThinMaterial)
            .clipShape(.circle)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
