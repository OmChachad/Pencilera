import SwiftUI
import StoreKit

struct TipJar: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    @EnvironmentObject var storeKit: Store
    
    var body: some View {
        NavigationStack {
            Form {
                Section("About the Developer") {
                    HStack {
                        Image("Om")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .shadow(radius: 2)
//                            .padding(.trailing)
                        
                        VStack(alignment: .leading) {
                            Text("Hi, I'm Om Chachad! 👋🏻")
                                .font(.title3.bold())
                            Text("I'm the developer behind Pencilera, thanks for checking out my app.\nI hope you are enjoying using it!")
                               // .frame(maxWidth: .infinity)
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
                
                Section {
                    
                    VStack(alignment: .leading) {
                        Text("🤔 Why should I tip?")
                            .font(.title3.bold())
                            .padding(.vertical, 5)
                        
                        Text("Tipping lets me, the sole developer of Pencilera, know that you're enjoying the app, helps sustain development and lets me keep the app 100% free for all users.")
                    }
                    
                    VStack(alignment: .leading) {
//                        Text("All Perks")
//                            .bold()
//                            .padding(.vertical, 5)
                        
                        VStack(spacing: 5) {
                            bulletLine("Appreciate the App", systemImage: "heart.fill", tint: .pink)
                            bulletLine("Support Indie Development", systemImage: "wrench.and.screwdriver.fill", tint: .blue)
                            bulletLine("Facilitate Future Updates", systemImage: "clock.arrow.2.circlepath", tint: .orange)
                            bulletLine("Keep the app Free-to-use", systemImage: "face.dashed", tint: .green)
                        }
                    }
                }
                
                if storeKit.tippableProducts.isEmpty {
                    ProgressView()
                } else {
                    Section {
                        List(storeKit.tippableProducts) { product in
                            TipItem(product: product)
                                .environmentObject(storeKit)
                        }
                    } footer: {
                        Text("""
                    I get 70% of how much you tip, 30% goes to Apple.
                    *All tips matter equally,* Thank you so much!
                    """)
                    }
                }
                
                Button("Restore Purchases") {
                    Task {
                        try? await AppStore.sync()
                    }
                }
                
                //            Section {
                //                Button {
                //                    openURL(URL(string:"https://apps.apple.com/app/id6449708232?mt=8&action=write-review")!)
                //                } label: {
                //                    Label("Write a Review", systemImage: "square.and.pencil")
                //                }
                //            } header: {
                //                Text("Can't tip? Other ways to support")
                //            }
            }
            .navigationTitle("Tip Jar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    func bulletLine(_ textContent: String, systemImage: String, tint: Color) -> some View {
        Label {
            Text(textContent)
        } icon: {
            Image(systemName: systemImage)
                .foregroundColor(tint)
                .frame(width: 10, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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

struct TipItem: View {
    @EnvironmentObject var storeKit: Store
    var product: Product
    
    @State private var isPurchasing = false
    
    var body: some View {
        HStack {
            Text("\(storeKit.emoji(for: product.id)) ")
                .font(.largeTitle)
            
            VStack(alignment: .leading, spacing: 2.5) {
                Text("\(product.displayName)")
                    .bold()
                Text(product.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.trailing, 5)
            
            Spacer()
            
            if storeKit.isPurchased(product) {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
                    .frame(width: 70)
            } else if isPurchasing {
                ProgressView()
            } else {
                Button(product.displayPrice) {
                    isPurchasing = true
                    Task {
                        try? await storeKit.purchase(product)
                        isPurchasing = false
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct TipJar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TipJar()
                .environmentObject(Store.shared)
        }
    }
}
