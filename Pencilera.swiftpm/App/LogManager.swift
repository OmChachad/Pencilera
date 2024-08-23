import Foundation
import Combine

class LogManager: ObservableObject {
    static let shared = LogManager()
    
    struct Log: Hashable {
        let title: String
        let type: LogType
        let time = Date()
        
        enum LogType {
            case error, print
        }
    }
    
    @Published private(set) var logs: [Log] = []
    
    func addLog(_ title: String, type: Log.LogType = .print) {
        DispatchQueue.main.async {
            let log = Log(title: title, type: type)
            self.logs.append(log)
        }
    }
}
