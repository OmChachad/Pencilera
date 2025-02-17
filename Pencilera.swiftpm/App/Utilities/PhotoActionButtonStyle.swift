import SwiftUI

struct PhotoActionButtonStyle: ButtonStyle {
    var tint: Color = .white
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(configuration.isPressed ? tint.opacity(0.1) : tint.opacity(0.2))
            .foregroundColor(tint)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.75 : 1.0)
            .animation(.easeOut(duration: 0.5), value: configuration.isPressed)
    }
}
