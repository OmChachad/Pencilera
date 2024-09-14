import Foundation
import SwiftUI
import Photos
import UniformTypeIdentifiers
import MobileCoreServices
import CoreLocation
import CoreLocationUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ViewfinderView
    
    init(picker: ViewfinderView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let capturedImage = info[.originalImage] as? UIImage else { return }
        guard let data = capturedImage.heicData() else { return }
        let dataModel = DataModel.instance
        dataModel.savePhoto(imageData: data)
    }
}
