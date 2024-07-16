import SwiftUI
import VariableBlurView

struct KeyframeAnimationModifier: ViewModifier {
    let totalDuration: Double
    @Binding var animate: Bool
    
    func body(content: Content) -> some View {
        content
            .keyframeAnimator(initialValue: AnimationProperties(), trigger: animate) { content, value in
                content
                    .scaleEffect(.init(width: value.verticalStretch, height: value.verticalStretch), anchor: .top)
                    .offset(y: value.translation)
            } keyframes: { _ in
                KeyframeTrack(\.verticalStretch) {
                    SpringKeyframe(1, duration: 0.5 * totalDuration)
                    SpringKeyframe(1.5, duration: 0.5 * totalDuration)
                }
                
                KeyframeTrack(\.translation) {
                    SpringKeyframe(0, duration: 0.5 * totalDuration)
                    SpringKeyframe(120, duration: 0.5 * totalDuration)
                }
            }
            .overlay(alignment: .bottom) {
                VariableBlurView(maxBlurRadius: 5)
                    .rotationEffect(.degrees(180))
                    .frame(maxHeight: 80, alignment: .bottom)
                    .ignoresSafeArea(.all)
            }
    }
}

extension View {
    func keyframeAnimation(totalDuration: Double = 2.0, animate: Binding<Bool>) -> some View {
        self.modifier(KeyframeAnimationModifier(totalDuration: totalDuration, animate: animate))
    }
}


struct AnimationProperties {
    var translation = 1.0
    var verticalStretch = 1.0
}
