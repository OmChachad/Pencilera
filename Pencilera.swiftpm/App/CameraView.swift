/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI

struct CameraView: View {
    @StateObject private var model = DataModel()
    @Environment(\.openURL) var openURL
    
    @State private var capturedPhoto = false
    
    @State private var isPortrait = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let outerStack = isPortrait ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
                outerStack {
                    ViewfinderView(image:  $model.viewfinderImage )
                        .cornerRadius(14)
                        .shadow(radius: 5)
                        .padding()
                    
                    buttonsView()
                }
                .background {
                    Color(.secondarySystemBackground)
                        .preferredColorScheme(.dark)
                        .ignoresSafeArea()
                }
                .task {
                    await model.camera.start()
                    await model.loadPhotos()
                    await model.loadThumbnail()
                }
                .navigationTitle("Camera")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                .ignoresSafeArea()
                .statusBar(hidden: true)
                .onPencilDoubleTap { _ in
                    capturePhoto()
                }
                .onPencilSqueeze { _ in
                    capturePhoto()
                }
                .onChange(of: geo.size.width <= geo.size.height) {
                    isPortrait = geo.size.width <= geo.size.height
                }
                .onAppear {
                    isPortrait = geo.size.width <= geo.size.height
                }
            }
        }
        .overlay {
            if capturedPhoto {
                Color.white
                    .ignoresSafeArea()
            }
        }
        .animation(.spring.speed(2), value: capturedPhoto)
    }
    
    private func capturePhoto() {
        model.camera.takePhoto()
        
        capturedPhoto = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            capturedPhoto = false
        }
    }
    
    private func buttonsView() -> some View {
        Group {
            let buttonsStack = !isPortrait ? AnyLayout(VStackLayout(spacing: 60)) : AnyLayout(HStackLayout(spacing: 60))
            buttonsStack {
                Spacer()
                
                NavigationLink {
                    PhotoCollectionView(photoCollection: model.photoCollection)
                        .onAppear {
                            model.camera.isPreviewPaused = true
                        }
                        .onDisappear {
                            model.camera.isPreviewPaused = false
                        }
                } label: {
                    Label {
                        Text("Gallery")
                    } icon: {
                        ThumbnailView(image: model.thumbnailImage)
                    }
                }
                
                Button {
                    capturePhoto()
                } label: {
                    Label {
                        Text("Take Photo")
                    } icon: {
                        ZStack {
                            Circle()
                                .strokeBorder(.white, lineWidth: 3)
                                .frame(width: 62, height: 62)
                            Circle()
                                .fill(.white)
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                
                Button {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        model.camera.switchCaptureDevice()
                    }
                } label: {
                    Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.white)
                }
                .padding(5)
                .background(.ultraThinMaterial)
                .clipShape(.circle)
                
                Spacer()
                
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .padding()
            .padding(!isPortrait ? .trailing : .bottom)
        }
    }
}

//struct FlipTransition: ViewModifier, Animatable {
//    var progress: CGFloat = 0
//    var animatableData: CGFloat {
//        get { progress }
//        set { progress = newValue }
//    }
//    func body(content: Content) -> some View {
//        content
//            .opacity(progress < 0 ? (-progress < 0.5 ? 1 : 0) : (progress < 0.5 ? 1 : 0))
//            .rotation3DEffect(.init(degrees: progress * 180), axis: (x: 0.0, y: 1.0, z: 0.0))
//    }
//    
//}
//
//extension AnyTransition {
//    static let flip: AnyTransition = modifier(
//        active: FlipTransition (progress: -1), identity: FlipTransition()
//    )
//    static let reverseFlip: AnyTransition = modifier(
//        active: FlipTransition (progress: 1), identity: FlipTransition())
//}
