import SwiftUI

struct FlashModePicker: View {
    @Binding var selection: CameraFlashMode
    
    var body: some View {
        Menu(selection.title, systemImage: selection.icon) {
            ForEach(CameraFlashMode.allCases, id: \.self) { mode in
                Button((selection == mode ? "✓   ": "      ") + mode.title, systemImage: mode.icon) { 
                    selection = mode
                }
                .accessibilityLabel("Flash \(mode.title)")
            }
        }
        .foregroundStyle(selection.color)
        .labelStyle(.iconOnly)
        .contentTransition(.symbolEffect(.replace))
    }
}
