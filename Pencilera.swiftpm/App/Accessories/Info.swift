import SwiftUI

struct InfoView: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Form {
            Section("Get in touch") {
                LabeledContent("Email") { 
                    Text("contact@starlightapps.org")
                }
            }
            
            Section {
                Link("View Source Code on GitHub", destination: URL(string: "https://github.com/OmChachad/Pencilera")!)
            }
            
            Section {
                HStack {
                    Link("Our Website", destination: URL(string: "https://starlightapps.org/")!)
                    
                    Spacer()
                    
                    Link("Privacy Policy", destination: URL(string: "http://starlightapps.org/privacy-policy")!)
                }
            }
        }
    }
}
