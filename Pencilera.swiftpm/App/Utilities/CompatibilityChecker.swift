import SwiftUI

class CompatibilityChecker {
    private let applePencilProiPadIdentifiers: [String] = ["iPad14,8",
                                                   "iPad14,9",
                                                   "iPad14,10",
                                                   "iPad14,11",
                                                   "iPad16,3",
                                                   "iPad16,4",
                                                   "iPad16,5",
                                                   "iPad16,6",
                                                   "iPad16,3-A",
                                                   "iPad16,3-B",
                                                   "iPad16,4-A",
                                                   "iPad16,4-B",
                                                   "iPad16,5-A",
                                                   "iPad16,5-B",
                                                   "iPad16,6-A",
                                                   "iPad16,6-B"]
    
    private var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelIdentifier = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
        return modelIdentifier
    }
    
    
    var isPencilProSupported: Bool {
        return applePencilProiPadIdentifiers.contains(modelIdentifier)
    }
}
