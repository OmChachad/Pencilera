import Photos
import SwiftUI

extension PHAsset {
    func getImage() -> Image? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var photo: UIImage?
        option.isSynchronous = true
        
        manager.requestImage(for: self,
                             targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                             contentMode: .aspectFit,
                             options: option) { result, info in
            if let result = result {
                photo = result
            }
        }
        
        guard let originalPhoto = photo else { return nil }
        
        return Image(uiImage: originalPhoto).resizable()
    }
}
