import SwiftUI
import FluidGradient

struct OnboardingBackground: View {
    let colors: [Color] = [
        Color(hex: "8EDC7A"),
        Color(hex: "FD4141"),
        Color(hex: "FDB241")
    ]
    
    var body: some View {
        FluidGradient(blobs: colors,
                      speed: 1.0,
                      blur: 0.75)
        .background(.black)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
