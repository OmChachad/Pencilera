import SwiftUI
//import Glur
import VariableBlurView

struct DoubleTap: View {
    @State private var animate = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Double Tap, Single Take.")
                .font(.largeTitle.bold())
                .foregroundStyle(LinearGradient(colors: [.white, .white.opacity(0.5)], startPoint: .top, endPoint: .bottom))
                .fontWidth(.expanded)
            Text("Double tap the stem of your Apple Pencil to capture a photo.")
            
            Spacer()
            
            Image("Apple Pencil 2")
                .resizable()
                .scaledToFit()
                .padding()
                .keyframeAnimation(totalDuration: 2.0, animate: $animate)
                .ignoresSafeArea(.all)
                .onAppear {
                    animate = true
                }
        }
        .ignoresSafeArea(.all)
        .multilineTextAlignment(.center)
    }
}
