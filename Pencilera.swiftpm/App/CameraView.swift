/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

    //@available(iOS 17.5, *)
struct CameraView: View {
    @StateObject private var model = DataModel()
    @Environment(\.openURL) var openURL
    
    @State private var currentOrientation = UIDevice.current.orientation
    
    @State private var capturedPhoto = false
    
    @State private var side = false
    
    var body: some View {
        NavigationStack {
            
                let outerStack = currentOrientation.isPortrait ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
                outerStack {
//                    ZStack {
////                        if side {
//                            ViewfinderView(image:  $model.viewfinderImage )
//                        
//                            .cornerRadius(14)
//                            .rotation3DEffect(.degrees(!side ? 0 : 180), axis: (x: 0, y: 1, z: 0))
//                            .opacity(!side ? 1 : 0)
////                                //.transition(.reverseFlip)
////                        } else {
//                            ViewfinderView(image:  $model.viewfinderImage )
////                        
////                            .cornerRadius(14)
////                            .rotation3DEffect(.degrees(side ? 180 : 0), axis: (x: 0, y: 1, z: 0))
////                            .opacity(side ? 1 : 0)
//                                //.transition(.flip)
//                        //}
//                    }
//                        .rotation3DEffect(.degrees(side ? 180 : 0), axis: (x: 0, y: 1, z: 0))
//                        .opacity(side ? 1 : 0)
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
                .onAppear {
                    print(UIDevice.current.model)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                             self.currentOrientation = UIDevice.current.orientation
                            }
        }
        .onAppear {
            currentOrientation = UIDevice.current.orientation
        }
        .overlay {
            if capturedPhoto {
                Color.white
                    .ignoresSafeArea()
            }
        }
        .animation(.spring.speed(2), value: capturedPhoto)
        .animation(.spring(duration: 1), value: side)
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
            let buttonsStack = currentOrientation.isLandscape ? AnyLayout(VStackLayout(spacing: 60)) : AnyLayout(HStackLayout(spacing: 60))
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
//                        Button {
//                            if let url = URL(string: "photos-navigation://") {
//                                if UIApplication.shared.canOpenURL(url) {
//                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                                }
//                            }
//                        } label: {
                            ThumbnailView(image: model.thumbnailImage)
                    //    }
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
                    
                    side.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        model.camera.switchCaptureDevice()
                       // side.toggle()
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
            .padding(currentOrientation.isLandscape ? .trailing : .bottom)
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
