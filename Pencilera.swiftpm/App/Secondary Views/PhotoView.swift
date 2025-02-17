/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import Photos

struct PhotoView: View {
    var asset: PhotoAsset
    var cache: CachedImageManager?
    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?
    @Environment(\.dismiss) var dismiss
    private let imageSize = CGSize(width: 1024, height: 1024)
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel(asset.accessibilityLabel)
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.secondary)
        .navigationTitle("Photo")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            buttonsView()
                .offset(x: 0, y: -50)
        }
        .task {
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result {
                        self.image = result.image
                    }
                }
            }
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Button("Favorite", systemImage: asset.isFavorite ? "heart.fill" : "heart") {
                Task {
                    await asset.setIsFavorite(!asset.isFavorite)
                }
            }
            
            if let image = asset.phAsset?.getImage() {
                ShareLink(item: image, preview: SharePreview("Pencilera Photo from " + (asset.phAsset?.creationDate ?? Date.now).formatted(date: .complete, time: .shortened), image: image))             
            }

            Button("Delete", systemImage: "trash", role: .destructive) {
                Task {
                    await asset.delete()
                    await MainActor.run {
                        dismiss()
                    }
                }
            }
        }
        .font(.system(size: 24))        
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
}
