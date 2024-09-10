import SwiftUI

struct ViewfinderView: UIViewControllerRepresentable {
    @Binding var flash: Bool
    @Binding var screenHeight: CGFloat
    @Binding var screenWidth: CGFloat
    
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
        }
        
        let cameraAspectRatio: CGFloat = 4.0 / 3.0
        let imageHeight = screenWidth * cameraAspectRatio
        var transform = CGAffineTransform(translationX: 0, y: (screenHeight - imageHeight) / 2)
        imagePicker.cameraViewTransform = transform
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        if flash == true {
            uiViewController.cameraFlashMode = .on
        } else {
            uiViewController.cameraFlashMode = .off
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}
