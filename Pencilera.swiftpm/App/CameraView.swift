/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI
import Combine

struct CameraView: View {
    @StateObject private var model = DataModel.instance
    @Environment(\.openURL) var openURL
    
    @State private var isPortrait = false
    
    @State private var capturePhotoSubject = PassthroughSubject<Void, Never>()
    @State private var cancellables = Set<AnyCancellable>()
    
    @State private var showTipJar = false
    @State private var showInfo = false
    @State private var showSettings = false
    
    @AppStorage("doubleTapEnabled") private var isDoubleTapEnabled = true
    @AppStorage("squeezeEnabled") private var isSqueezeEnabled = true
    
    @AppStorage("CameraFlash") private var flashMode: CameraFlashMode = .auto
    
    @AppStorage("Modeldentifier") var modelIdentifier = ""
    
    var isPencilProSupported: Bool {
        let applePencilProiPadIdentifiers: [String] = ["iPad14,8",
                                                       "iPad14,9",
                                                       "iPad14,10",
                                                       "iPad14,11",
                                                       "iPad16,3",
                                                       "iPad16,4",
                                                       "iPad16,5",
                                                       "iPad16,6",
                                                       "iPad16,3-A",
                                                       "iPad16,3-B",
                                                       "iPad16,4-A",
                                                       "iPad16,4-B",
                                                       "iPad16,5-A",
                                                       "iPad16,5-B",
                                                       "iPad16,6-A",
                                                       "iPad16,6-B"]
        return applePencilProiPadIdentifiers.contains(modelIdentifier)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let outerStack = isPortrait ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
                outerStack {
                    ViewfinderView(flashMode: self.flashMode, screenHeight: geo.size.height, screenWidth: geo.size.width)
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
                    await model.loadPhotos()
                    await model.loadThumbnail()
                }
                .navigationTitle("Camera")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                .ignoresSafeArea()
                .statusBar(hidden: true)
                .onPencilDoubleTap { _ in
                    if isDoubleTapEnabled {
                        capturePhotoSubject.send()
                    }
                }
                .onPencilSqueeze { _ in
                    if isSqueezeEnabled {
                        capturePhotoSubject.send()
                    }
                }
                .onChange(of: geo.size.width <= geo.size.height) {
                    isPortrait = geo.size.width <= geo.size.height
                }
                .onAppear {
                    isPortrait = geo.size.width <= geo.size.height
                    setupDebouncedCapture()
                }
            }
        }
    }
    
    private func setupDebouncedCapture() {
        capturePhotoSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink {
                self.performCapture()
            }
            .store(in: &cancellables)
    }
    
    func switchCamera() {
        NotificationCenter.default.post(name: NSNotification.Name("SwitchCamera"), object: nil)
    }
    
    private func performCapture() {
        NotificationCenter.default.post(name: NSNotification.Name("TakePictureNotification"), object: nil)
    }
    
    private func buttonsView() -> some View {
        let sidebarStack = !isPortrait ? AnyLayout(VStackLayout(spacing: 60)) : AnyLayout(HStackLayout(spacing: 60))
        
        let secondaryButtonStack = !isPortrait ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(spacing: 15))
        
        return ZStack {
            sidebarStack {
                
               // if isPencilProSupported {
                    Button("Settings", systemImage: "gear") {
                        showSettings.toggle()
                    }
                    .popover(isPresented: $showSettings) {
                        Settings()
                            .frame(width: 400, height: 300)
                    }
                    .hoverEffect(.lift)
            //    }
                
                Spacer()
                
                secondaryButtonStack {
                    Button("Tip Jar", systemImage: "heart.fill") {
                        showTipJar.toggle()
                    }
                    .foregroundColor(.pink)
                    .hoverEffect(.lift)
                    
                    Button("Info", systemImage: "info.circle") {
                        showInfo.toggle()
                    }
                    .hoverEffect(.lift)
                }

            }
            .font(.system(size: 20, weight: .regular))
            
            sidebarStack {
                Group {
                    Spacer()
                    
                    NavigationLink {
                        PhotoCollectionView(photoCollection: model.photoCollection)
//                            .onAppear {
//                                model.camera.isPreviewPaused = true
//                            }
//                            .onDisappear {
//                                model.camera.isPreviewPaused = false
//                            }
                    } label: {
                        Label {
                            Text("Gallery")
                        } icon: {
                            ThumbnailView(image: model.thumbnailImage)
                        }
                    }
                    
                    Button {
                        capturePhotoSubject.send()
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
                    
                    secondaryButtonStack {
                        Button {
                            switchCamera()
                        } label: {
                            Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                                .foregroundColor(.white)
                                .font(.system(size: 25, weight: .regular))
                        }
                        
                        FlashModePicker(selection: $flashMode)
                            .font(.system(size: 20, weight: .regular))
                    }
                    .buttonStyle(CircularButtonStyle())
                    
                    Spacer()
                }
                .hoverEffect(.lift)
            }
            .sheet(isPresented: $showTipJar) {
                TipJar()
            }
            .sheet(isPresented: $showInfo) {
                InfoView()
            }
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
        .padding(!isPortrait ? .trailing : .bottom)
        .padding(!isPortrait ? .vertical : .horizontal)
    }
}
