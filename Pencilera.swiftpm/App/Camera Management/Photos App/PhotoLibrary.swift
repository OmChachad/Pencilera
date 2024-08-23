/*
See the License.txt file for this sample’s licensing information.
*/

import Photos
import os.log

class PhotoLibrary {

    static func checkAuthorization() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            LogManager.shared.addLog("Photo library access authorized.")
            return true
        case .notDetermined:
            LogManager.shared.addLog("Photo library access not determined.")
            return await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
        case .denied:
            LogManager.shared.addLog("Photo library access denied.")
            return false
        case .limited:
            LogManager.shared.addLog("Photo library access limited.")
            return false
        case .restricted:
            LogManager.shared.addLog("Photo library access restricted.")
            return false
        @unknown default:
            return false
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "PhotoLibrary")

