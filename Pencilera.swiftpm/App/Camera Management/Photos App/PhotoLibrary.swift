/*
See the License.txt file for this sample’s licensing information.
*/

import Photos
import os.log

class PhotoLibrary {

    static func checkAuthorization() async -> Bool {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        var hasAccess: Bool
        
        switch authorizationStatus {
        case .authorized:
            LogManager.shared.addLog("Photo library access authorized.")
            hasAccess = true
        case .notDetermined:
            LogManager.shared.addLog("Photo library access not determined.")
            hasAccess = await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
        case .denied:
            LogManager.shared.addLog("Photo library access denied.")
            hasAccess = false
        case .limited:
            LogManager.shared.addLog("Photo library access limited.")
            hasAccess = false
        case .restricted:
            LogManager.shared.addLog("Photo library access restricted.")
            hasAccess = false
        @unknown default:
            hasAccess = false
        }
        
        UserDefaults.standard.setValue(hasAccess, forKey: "HasGrantedPhotoAccess")
        return hasAccess
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "PhotoLibrary")

