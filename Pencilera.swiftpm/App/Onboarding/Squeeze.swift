import SwiftUI
import VariableBlurView

struct Squeeze: View {
    @State private var animate = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(" PENCIL PRO ONLY")
                .foregroundStyle(Gradient(colors: [.secondary.opacity(1), .secondary.opacity(0.5)]))
                .font(.headline)
                .padding(10)
                .background(Color.gray.gradient.opacity(0.2))
                .cornerRadius(10)
            
            Group {
                Text("Say ") + Text("~~Cheese~~ ").fontWeight(.thin)                 + Text("Squeeze!").italic()//.fontWidth(.condensed)
            }
            .font(.largeTitle.bold())
            .foregroundStyle(LinearGradient(colors: [.white, .white.opacity(0.5)], startPoint: .top, endPoint: .bottom))
            
            Text("Apple Pencil Pro allows you to take photos by squeezing your pencil.")
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Image("Apple Pencil Pro")
                .resizable()
                .scaledToFit()
                .padding()
                .keyframeAnimation(totalDuration: 2.0, animate: $animate)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        animate = true
                    }
                }
        }
        .ignoresSafeArea()
        .multilineTextAlignment(.center)
    }
}
