import SwiftUI

import SwiftUI
//import Glur
import VariableBlurView

struct StartUsingView: View {
    @Environment(\.dismiss) var dismiss
    
    struct DisplayItem {
        var icon: String
        var color: Color
        var title: String
        var description: String
    }
    
    let displayItems: [DisplayItem] = [
        DisplayItem(icon: "swift", color: .orange, title: "Built with Swift Playgrounds", description: "Pencilera was built entirely on iPad using Swift Playgrounds."),
        DisplayItem(icon: "curlybraces", color: .purple, title: "Open Source", description: "Pencilera is open-sourced on GitHub!"),
        DisplayItem(icon: "banknote.fill", color: .green, title: "Completely Free", description: "The app is completely free to use with optional tips to support development."),
        DisplayItem(icon: "heart.fill", color: .pink, title: "Built with Love", description: "Built with love by an indie developer."),
//        DisplayItem(icon: Image(systemName: "applepencil.gen2"), color: <#T##Color#>, title: <#T##String#>, description: <#T##String#>)
    ]
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Welcome to Pencilera")
                .font(.largeTitle.bold())
                .foregroundStyle(LinearGradient(colors: [.white, .white.opacity(0.5)], startPoint: .top, endPoint: .bottom))
                .fontWidth(.expanded)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 30) {
                ForEach(displayItems, id: \.title) { item in
                    HStack {
                        Image(systemName: item.icon)
                            .font(.system(size: 44))
                            .foregroundColor(item.color)
                            .frame(width: 70)
                        
                        VStack(alignment: .leading, content: {
                            Text(item.title)
                                .bold()
                            Text(item.description)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                        })
                    }
                }
            }
                            .frame(width: 400)
            
            Spacer()
            
            Button(action: dismiss.callAsFunction) {
                Text("Start Using")
                .frame(minWidth: 400)
                .foregroundStyle(.ultraThickMaterial)
                .environment(\.colorScheme, .dark)
                .font(.title3)
                .bold()
                .padding()
                .background(.white.gradient)
                .clipShape(Capsule())
                .hoverEffect(.lift)
            }
            
            Spacer()
        }
        .multilineTextAlignment(.center)
    }
}
