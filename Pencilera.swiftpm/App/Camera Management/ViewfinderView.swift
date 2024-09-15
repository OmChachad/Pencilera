import SwiftUI

struct ViewfinderView: UIViewControllerRepresentable {
    @Binding var isFlashSupported: Bool
    var flashMode: CameraFlashMode
    var screenHeight: CGFloat
    var screenWidth: CGFloat
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        imagePicker.showsCameraControls = false
        imagePicker.cameraDevice = .front

        NotificationCenter.default.addObserver(forName: NSNotification.Name("TakePictureNotification"), object: nil, queue: .main) { _ in
            imagePicker.takePicture()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SwitchCamera"), object: nil, queue: .main) { _ in
            if imagePicker.cameraDevice == .rear {
                imagePicker.cameraDevice = .front
            } else {
                imagePicker.cameraDevice = .rear
            }
            isFlashSupported = UIImagePickerController.isFlashAvailable(for: imagePicker.cameraDevice)
        }
        
        let cameraAspectRatio: CGFloat = 4.0 / 3.0
        let imageHeight = screenWidth * cameraAspectRatio
        var transform = CGAffineTransform(translationX: 0, y: (screenHeight - imageHeight) / 2)
        imagePicker.cameraViewTransform = transform
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        isFlashSupported = UIImagePickerController.isFlashAvailable(for: uiViewController.cameraDevice)
        uiViewController.cameraFlashMode = flashMode.toSystemMode()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}
