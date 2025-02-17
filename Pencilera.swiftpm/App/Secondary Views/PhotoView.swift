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
        .navigationTitle(asset.phAsset?.creationDate?.formatted(date: .complete, time: .shortened) ?? "Photo")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            buttonsView()
                .padding(.bottom, 20)
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
        HStack(spacing: 20) {
            Button("Favorite", systemImage: asset.isFavorite ? "heart.fill" : "heart") {
                Task {
                    await asset.setIsFavorite(!asset.isFavorite)
                }
            }
            .buttonStyle(PhotoActionButtonStyle(tint: .pink))
            
            if let image = asset.phAsset?.getImage() {
                ShareLink(item: image, preview: SharePreview("Pencilera Photo from " + (asset.phAsset?.creationDate ?? Date.now).formatted(date: .complete, time: .shortened), image: image))
                .buttonStyle(PhotoActionButtonStyle(tint: .blue))
            }

            Button("Delete", systemImage: "trash.fill", role: .destructive) {
                Task {
                    await asset.delete()
                    await MainActor.run {
                        dismiss()
                    }
                }
            }
            .buttonStyle(PhotoActionButtonStyle(tint: .red))
        }
        .font(.system(size: 20))        
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding(7.5)
        .background {
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(radius: 10)
                .background {
                    Color.primary.colorInvert().opacity(0.6)
                        .clipShape(.capsule)
                }
        }
    }
}
