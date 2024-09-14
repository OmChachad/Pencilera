import SwiftUI

enum CameraFlashMode: Int, Codable, CaseIterable {
    case auto = 0
    case on = 1
    case off = 2
    
    var title: String {
        switch self {
        case .off:
            return "Off"
        case .on:
            return "On"
        case .auto:
            return "Auto"
        }
    }
    
    var icon: String {
        switch self {
        case .off:
            return "bolt.slash.fill"
        case .on:
            return "bolt.fill"
        case .auto:
            return "bolt.badge.automatic.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .on:
            return .yellow
        default:
            return .white
        }
    }
    
    init(systemMode: UIImagePickerController.CameraFlashMode) {
        self = CameraFlashMode(rawValue: systemMode.rawValue) ?? CameraFlashMode.off
    }
    
    func toSystemMode() -> UIImagePickerController.CameraFlashMode {
        return UIImagePickerController.CameraFlashMode(rawValue: self.rawValue) ?? .off
    }
}
