//
//  SORAPhoto.swift
//

import Foundation
import PhotosUI

public class SORAPhotoPickerResult {
    public var id = UUID().uuidString
    public var phPickerResult: PHPickerResult
    public var typeIdentifiers: [String] {
        return self.phPickerResult.itemProvider.registeredTypeIdentifiers
    }
    
    init(pickerResult: PHPickerResult) {
        self.phPickerResult = pickerResult
    }
    
    public func isImage() -> Bool {
        return  typeIdentifiers.contains("public.jpeg") ||
                typeIdentifiers.contains("public.png") ||
                typeIdentifiers.contains("com.compuserve.gif")
    }
    
    public var suggestedName: String? {
        return self.phPickerResult.itemProvider.suggestedName
    }
    
    public func loadUIImage(completion: @escaping(UIImage?, Error?)->Void) {    
        if self.phPickerResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
            self.loadImage() { image, error in
                completion(image, error)
            }
        } else {
            completion(nil, SORAPhotoPickerError.createError(reason: .failedToLoadImage))
        }
    }
    
    public func loadImageURL(completion: @escaping(URL?, Error?)->Void) {
        if self.phPickerResult.itemProvider.hasItemConformingToTypeIdentifier("public.heic") {
            self.loadPhotoWithIdentifier("public.heic") { url, error in
                if let url = url {
                    let copiedURL = SORAFileManager.copyToTempDirectory(fileURL: url)
                    completion(copiedURL, error)
                } else {
                    completion(nil, error)
                }
            }
        } else if self.phPickerResult.itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") {
            self.loadPhotoWithIdentifier("public.jpeg") { url, error in
                if let url = url {
                    let copiedURL = SORAFileManager.copyToTempDirectory(fileURL: url)
                    completion(copiedURL, error)
                } else {
                    completion(nil, error)
                }
            }
        } else if self.phPickerResult.itemProvider.hasItemConformingToTypeIdentifier("com.compuserve.gif") {
            self.loadPhotoWithIdentifier("com.compuserve.gif") { url, error in
                if let url = url {
                    let copiedURL = SORAFileManager.copyToTempDirectory(fileURL: url)
                    completion(copiedURL, error)
                } else {
                    completion(nil, error)
                }
            }
        } else {
            let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Failed to load image", comment: "")]
            let error = NSError.init(domain: "com.sportsyou.sportsyouapp", code: 400, userInfo: userInfo)
            completion(nil, error)
        }
    }
    
    
    public func loadVideo(completion: @escaping(URL?, Error?)->Void) {
        if self.phPickerResult.itemProvider.hasItemConformingToTypeIdentifier("com.apple.quicktime-movie") {
            self.loadPhotoWithIdentifier("com.apple.quicktime-movie") { url, error in
                if let url = url {
                    let copiedURL = SORAFileManager.copyToTempDirectory(fileURL: url)
                    completion(copiedURL, error)
                } else {
                    completion(nil, error)
                }
            }
        } else if self.phPickerResult.itemProvider.hasItemConformingToTypeIdentifier("public.mpeg-4") {
            self.loadPhotoWithIdentifier("public.mpeg-4") { url, error in
                if let url = url {
                    let copiedURL = SORAFileManager.copyToTempDirectory(fileURL: url)
                    completion(copiedURL, error)
                } else {
                    completion(nil, error)
                }
            }
        } else {
            completion(nil, NSError.init(domain: "com.codediary.soraphotopicker", code: 200, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Unknown video type", comment:"")]))
        }
    }
    
    func loadObject() {
        if self.phPickerResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
            self.loadImage() { image, error in
            }
        } else if self.phPickerResult.itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
            self.loadLivePhoto() { livePhoto, error in
            }
        } else if self.phPickerResult.itemProvider.hasItemConformingToTypeIdentifier("com.apple.quicktime-movie") {
            self.loadPhotoWithIdentifier("com.apple.quicktime-movie") { url, error in
            }
        } else if self.phPickerResult.itemProvider.hasItemConformingToTypeIdentifier("public.mpeg-4") {
            self.loadPhotoWithIdentifier("public.mpeg-4") { url, error in
            }
        } else if self.phPickerResult.itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") {
            self.loadPhotoWithIdentifier("public.jpeg") { url, error in
            }
        } else if self.phPickerResult.itemProvider.hasItemConformingToTypeIdentifier("public.heic") {
            self.loadPhotoWithIdentifier("public.heic") { url, error in
            }
        }
    }
    
    private func loadImage(completion: @escaping(UIImage?, Error?)->()) {
        self.phPickerResult.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            if let uiImage = image as? UIImage {
                completion(uiImage, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    private func loadLivePhoto(completion: @escaping(PHLivePhoto?, Error?)->()) {
        self.phPickerResult.itemProvider.loadObject(ofClass: PHLivePhoto.self) { livePhoto, error in
            if let livePhoto = livePhoto as? PHLivePhoto {
                completion(livePhoto, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    private func loadPhotoWithIdentifier(_ identifier: String, completion: @escaping(URL?, Error?)->()) {
        self.phPickerResult.itemProvider.loadFileRepresentation(forTypeIdentifier: identifier) { fileURL, error in
            if let videoURL = fileURL {
                completion(videoURL, error)
            } else {
                completion(nil, error)
            }
        }
    }
}
