import SwiftUI

struct Settings: View {
    @AppStorage("doubleTapEnabled") private var isDoubleTapEnabled = true
    @AppStorage("squeezeEnabled") private var isSqueezeEnabled = true
    
    @State private var showLogsView = false
    
    private var atLeastOneEnabled: Bool {
        isDoubleTapEnabled || isSqueezeEnabled
    }
    
    var body: some View {
        Form {
            Section {
                Toggle("Double Tap to Capture", isOn: Binding(
                    get: { isDoubleTapEnabled },
                    set: { newValue in
                        if !newValue && !isSqueezeEnabled {
                            isSqueezeEnabled = true
                        }
                        isDoubleTapEnabled = newValue
                    }
                ))
                Toggle("Squeeze to Capture", isOn: Binding(
                    get: { isSqueezeEnabled },
                    set: { newValue in
                        if !newValue && !isDoubleTapEnabled {
                            isDoubleTapEnabled = true
                        }
                        isSqueezeEnabled = newValue
                    }
                ))
            }
            
            Section("Advanced") {
                Button("View Logs") {
                    showLogsView = true
                }
                .sheet(isPresented: $showLogsView) {
                    LogsView()
                }
            }
        }
    }
}
