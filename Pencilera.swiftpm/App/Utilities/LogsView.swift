import SwiftUI

struct LogsView: View {
    @ObservedObject var Logger = LogManager.shared
    
    var body: some View {
        NavigationStack {
            if Logger.logs.isEmpty {
                ContentUnavailableView("No logs- yet.", systemImage: "list.bullet.rectangle.portrait.fill")
            } else {
                Form {
                    ForEach(Logger.logs.reversed(), id: \.self) { log in
                        Text(log.title)
                            .foregroundStyle(log.type == .error ? .yellow : .primary)
                    }       
                    .font(.system(.body, design: .monospaced, weight: .regular))
                }    
                .navigationTitle("Logs")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
