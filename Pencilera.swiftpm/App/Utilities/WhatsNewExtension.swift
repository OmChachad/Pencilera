import SwiftUI
import WhatsNewKit

extension Pencilera: WhatsNewCollectionProvider {
    
    var whatsNewCollection: WhatsNewCollection {
        WhatsNew(
            version: "1.0.1",
            title: "What's New in Version 2.0",
            features: [
                WhatsNew.Feature(
                    image: .init(systemName: "ipad.sizes",                     foregroundColor: .blue),
                    title: "iPad Pro M4 Now Supported",
                    subtitle: "A major bug in the previous version, preventing M4 iPad Pro users from saving photos, is now fixed."
                ),
                WhatsNew.Feature(
                    image: .init(systemName: "camera.aperture",                     foregroundColor: .gray),
                    title: "Switch Between Lenses",
                    subtitle: "You can now switch between the Wide or Ultrawide lens on your iPad."
                ),
                WhatsNew.Feature(
                    image: .init(systemName: "plus.magnifyingglass",                     foregroundColor: .orange),
                    title: "Zoom Support",
                    subtitle: "You can now zoom into subjects from your iPad's back camera."
                ),
                WhatsNew.Feature(
                    image: .init(systemName: "bolt.fill",                     foregroundColor: .yellow),
                    title: "Flash Support",
                    subtitle: "Switch between three flash modes: On, Off, Auto"
                ),
                WhatsNew.Feature(
                    image: .init(systemName: "arrow.triangle.2.circlepath",                     foregroundColor: .white),
                    title: "Remote Camera Flip",
                    subtitle: "On Apple Pencil Pro, assign either gesture to switch camera lenses between front and back."
                ),
                WhatsNew.Feature(
                    image: .init(systemName: "gauge.with.dots.needle.67percent",                     foregroundColor: .green),
                    title: "Performance and Stablity Improvements",
                    subtitle: "The app was completely re-written to improve performance. An improvement that won't go unnoticed."
                ),
                
            ],
            primaryAction: WhatsNew.PrimaryAction(
                title: "Start Capturing",
                backgroundColor: .accentColor,
                foregroundColor: .white
            )
        )
    }
}
