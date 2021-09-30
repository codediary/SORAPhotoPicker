//
//  File.swift
//  
//
//  Created by codediary on 9/29/21.
//

import Foundation

enum SORAPhotoPickerError: Int {
    case failedToLoadImage = 1000, unexpected
}

extension SORAPhotoPickerError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .failedToLoadImage:
            return NSLocalizedString("Failed to load image", comment: "")
        case .unexpected:
            return NSLocalizedString("An unexpected error occurred.", comment: "")
        }
    }
}

extension SORAPhotoPickerError {
    var isFatal: Bool {
        if case SORAPhotoPickerError.unexpected = self {
            return true
        } else {
            return false
        }
    }
}

extension SORAPhotoPickerError {
    static func createError(reason: SORAPhotoPickerError) -> Error {
        return NSError.init(domain: "com.codediary.soraphotopicker",
                            code: reason.rawValue,
                            userInfo: [NSLocalizedDescriptionKey : reason.description])
    }
}
