//
//  SORAPhotoPicker.swift
//  SORAPhotoPicker
//
//  Created by codediary on 9/4/21.
//

import Foundation
import SwiftUI
import PhotosUI

public struct SORAPhotoPicker: View {
    var conf: PHPickerConfiguration
    let completion: (_ pickerResult:[SORAPhotoPickerResult]) -> Void
    public var body: some View {
        return UIImagePicker(conf: conf, completion:{ pickerResults in
            let photos = pickerResults.map { result in
                SORAPhotoPickerResult(pickerResult: result)
            }
            completion(photos)
        })
    }
}

struct UIImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    let conf: PHPickerConfiguration
    let completion: (_ pickerResult:[PHPickerResult]) -> Void
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let pickerController = PHPickerViewController(configuration: conf)
        pickerController.delegate = context.coordinator
        return pickerController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let picker: UIImagePicker
        
        init(_ picker: UIImagePicker) {
            self.picker = picker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            self.picker.completion(results)
            self.picker.presentationMode.wrappedValue.dismiss()
        }
        
    }
}
