import SwiftUI

struct InfoView: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Form {
            Section("About the Developer") {
                HStack {
                    Image("Om")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                    
                    VStack(alignment: .leading) {
                        Text("Hi, I'm Om Chachad! 👋🏻")
                            .font(.title3.bold())
                        Text("I'm the developer behind Pencilera, thanks for checking out my app.\nI hope you are enjoying using it!")
                            .foregroundColor(.secondary)
                        HStack {
                            socialLink(url: "https://www.youtube.com/TheiTE")
                            socialLink(url: "https://itecheverything.com")
                            socialLink(url: "https://twitter.com/TheOriginaliTE")
                        }
                    }
                    .multilineTextAlignment(.leading)
                }
            }
            
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
    
    
    private func socialLink(url: String) -> some View {
        let url: URL = URL(string: url) ?? URL(string: "https://starlightapps.org")!
        
        return VStack {
            symbol(for: url)
                .padding(5)
                .padding(.horizontal, 10)
                .background(.secondary.opacity(0.15))
                .cornerRadius(20)
        }.onTapGesture {
            openURL(url)
        }
        .hoverEffect(.lift)
    }
    
    private func symbol(for url: URL) -> some View {
        Group {
            switch url.host {
            case "www.youtube.com":
                YouTube()
                    .foregroundColor(.red)
            case "twitter.com":
                Twitter()
                    .foregroundColor(Color(red: 0.0, green: 0.6745, blue: 0.9333))
            default:
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.blue)
            }
        }
        .frame(width: 22.5, height: 22.5)
    }
}