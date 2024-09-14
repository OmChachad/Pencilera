/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var model = DataModel.instance
    @Environment(\.openURL) var openURL
    
    @State private var isPortrait = false
    
    @State private var capturePhotoSubject = PassthroughSubject<Void, Never>()
    @State private var cancellables = Set<AnyCancellable>()
    
    @State private var showTipJar = false
    @State private var showInfo = false
    @State private var showSettings = false
    
    @AppStorage("DoubleTapAction") private var doubleTapAction: Settings.PencilAction = .capture
    @AppStorage("SqueezeAction") private var squeezeAction: Settings.PencilAction = .capture
    
    @AppStorage("CameraFlash") private var flashMode: CameraFlashMode = .auto
    
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
                    performAction(action: doubleTapAction)
                }
                .onPencilSqueeze { _ in
                    performAction(action: squeezeAction)
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
    
    func performAction(action: Settings.PencilAction) {
        switch action {
        case .nothing:
            break
        case .capture:
            capturePhotoSubject.send()
        case .switchCamera:
            switchCamera()
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
                
                if CompatibilityChecker().isPencilProSupported {
                    Button("Settings", systemImage: "gear") {
                        showSettings.toggle()
                    }
                    .popover(isPresented: $showSettings) {
                        Settings()
                            .frame(width: 400, height: 300)
                    }
                    .hoverEffect(.lift)
                }
                
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
