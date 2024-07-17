/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI

@main
struct Pencilera: App {
    @ObservedObject var storeKit = Store.shared
    @AppStorage("firstTime") var isFirstTime: Bool = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isFirstTime {
                    OnboardingBackground()
                        .ignoresSafeArea(.all)
                } else {
                    CameraView()
                        .environmentObject(storeKit)
                }
            }
            .sheet(isPresented: $isFirstTime, content: {
                OnboardingView()
                    .presentationBackground(Material.regular)
            })
            .animation(.default, value: isFirstTime)
        }
    }
}
