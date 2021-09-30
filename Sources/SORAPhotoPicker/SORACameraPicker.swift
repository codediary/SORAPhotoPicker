//
//  SORACameraPicker.swift
//
//  Created by codediary on 9/4/21.
//

#if os(iOS)
import SwiftUI
import UIKit
import MobileCoreServices

public struct SORACameraPicker: View {
    @Environment(\.presentationMode) var presentationMode
    
    var onDismiss: (()->())?
    var onCapturePhoto: (UIImage)->()
    var onCaptureVideo: (URL) -> ()
    public init(onDismiss:(()->())?, onCapturePhoto: @escaping(UIImage)->(), onCaptureVideo: @escaping(URL)->()){
        self.onDismiss = onDismiss
        self.onCapturePhoto = onCapturePhoto
        self.onCaptureVideo = onCaptureVideo
    }
    public var body: some View {
        CameraPickerView(sourceType: .camera) { uiImage, url in
            if uiImage == nil && url == nil {
                onDismiss?()
            } else if let image = uiImage {
                onCapturePhoto(image)
            } else if let videoURL = url {
                onCaptureVideo(videoURL)
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
    
private struct CameraPickerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias SourceType = UIImagePickerController.SourceType

    let sourceType: SourceType
    let completionHandler: (UIImage?, URL?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.delegate = context.coordinator
        viewController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? [kUTTypeVideo as String]
        viewController.sourceType = sourceType
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completionHandler: completionHandler)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let completionHandler: (UIImage?, URL?) -> Void
        
        init(completionHandler: @escaping (UIImage?, URL?) -> Void) {
            self.completionHandler = completionHandler
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if info[UIImagePickerController.InfoKey.mediaType] as? String == "public.movie" {
                let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                completionHandler(nil, mediaURL) //todo: URL here
            } else if info[UIImagePickerController.InfoKey.mediaType] as? String == "public.image" {
                let image: UIImage? = {
                    if let image = info[.editedImage] as? UIImage {
                        return image
                    }
                    return info[.originalImage] as? UIImage
                }()
                completionHandler(image, nil)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            completionHandler(nil, nil)
        }
    }
    
}
#endif

