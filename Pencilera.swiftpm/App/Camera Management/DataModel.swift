/*
See the License.txt file for this sample’s licensing information.
*/

import AVFoundation
import SwiftUI
import os.log

final class DataModel: ObservableObject {
    static let instance = DataModel()
    let photoCollection = PhotoCollection(smartAlbum: .smartAlbumUserLibrary)
    
    @Published var thumbnailImage: Image?
    
    var isPhotosLoaded = false
    
    init() { }

    func savePhoto(imageData: Data) {
        Task {
            do {
                try await photoCollection.addImage(imageData)
                await loadThumbnail()
                logger.debug("Added image data to photo collection.")
                LogManager.shared.addLog("Added image data to photo collection.")
            } catch let error {
                logger.error("Failed to add image to photo collection: \(error.localizedDescription)")
                LogManager.shared.addLog("Failed to add image to photo collection: \(error.localizedDescription)", type: .error)
            }
        }
    }
    
    func loadPhotos() async {
        guard !isPhotosLoaded else { return }
        
        let authorized = await PhotoLibrary.checkAuthorization()
        guard authorized else {
            LogManager.shared.addLog("Photo library access was not authorized.")
            return
        }
        
        Task {
            do {
                try await self.photoCollection.load()
                await self.loadThumbnail()
            } catch let error {
                LogManager.shared.addLog("Failed to load photo collection: \(error.localizedDescription)", type: .error)
            }
            self.isPhotosLoaded = true
        }
    }
    
    func loadThumbnail() async {
        guard let asset = photoCollection.photoAssets.first  else { return }
        await photoCollection.cache.requestImage(for: asset, targetSize: CGSize(width: 256, height: 256))  { result in
            if let result = result {
                Task { @MainActor in
                    self.thumbnailImage = result.image
                }
            }
        }
    }
}

fileprivate struct PhotoData {
    var thumbnailImage: Image
    var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

fileprivate let logger = Logger(subsystem: appIdentifier, category: "DataModel")
