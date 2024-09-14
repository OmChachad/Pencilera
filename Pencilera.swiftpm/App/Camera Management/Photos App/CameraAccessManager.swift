import SwiftUI

import AVFoundation
import UIKit

class CameraAccessManager {
    static let shared = CameraAccessManager()
    
    private init() {}
    
    func checkCameraAccess() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    UserDefaults.standard.setValue(granted, forKey: "HasGrantedCameraAccess")
                }
            }
        case .restricted, .denied:
            UserDefaults.standard.setValue(false, forKey: "HasGrantedCameraAccess")
        case .authorized:
            UserDefaults.standard.setValue(true, forKey: "HasGrantedCameraAccess")
        @unknown default:
            UserDefaults.standard.setValue(false, forKey: "HasGrantedCameraAccess")
        }
    }
}
