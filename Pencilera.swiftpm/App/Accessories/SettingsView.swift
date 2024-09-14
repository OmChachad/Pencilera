import SwiftUI

struct Settings: View {
    @AppStorage("DoubleTapAction") private var doubleTapAction: PencilAction = .capture
    @AppStorage("SqueezeAction") private var squeezeAction: PencilAction = .capture
    
    @State private var showLogsView = false
    
    enum PencilAction: Int, CaseIterable, Codable {
        case nothing = 0
        case capture = 1
        case switchCamera = 2
        
        var title: String {
            switch self {
            case .nothing:
                "Do Nothing"
            case .capture:
                "Take Photo"
            case .switchCamera:
                "Switch Camera"
            }
        }
    }
    
    var body: some View {
        Form {
            Section {
                pencilActionPicker("Double Tap Action", selection: $doubleTapAction)
                pencilActionPicker("Squeeze Action", selection: $squeezeAction)
            } footer: {
                if doubleTapAction == squeezeAction && squeezeAction != .capture {
                    Text("\(Image(systemName: "exclamationmark.triangle")) Your settings prevent you from using your Apple Pencil are a remote to capture photos.")
                        .font(.footnote)
                        .foregroundStyle(.yellow)
                }
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
    
    func pencilActionPicker(_ title: String, selection: Binding<PencilAction>) -> some View {
        Picker(title, selection: selection) { 
            ForEach(PencilAction.allCases, id: \.self) {
                Text($0.title)
            }
        }
    }
}
