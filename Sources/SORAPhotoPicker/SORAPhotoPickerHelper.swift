//
//  SORAPhotoPickerHelper.swift
//
//  Created by codediary on 9/4/21.
//

import Foundation
import PhotosUI
import SwiftUI

@available (iOS 14.0, *)
public class SORAPhotoPickerHelper {
    public static let shared = SORAPhotoPickerHelper()
    
    public func picker(completion: @escaping([SORAPhotoPickerResult]) -> Void) -> SORAPhotoPicker {
        var conf = PHPickerConfiguration()
        conf.selectionLimit = 0
        conf.preferredAssetRepresentationMode = .current
        conf.filter = .any(of: [.images, .livePhotos, .videos])
        return SORAPhotoPicker(conf: conf, completion: completion)
    }
    
    
    public func pickerActionSheetButtons(onSelectCamera:@escaping()->(), onSelectImageLibrary:@escaping()->()) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        buttons.append(
            ActionSheet.Button.default(Text(NSLocalizedString("Camera", comment: "")),
                                       action: {
                                        onSelectCamera()
                                       })
        )
        buttons.append(
            ActionSheet.Button.default(Text(NSLocalizedString("Image Library", comment: "")),
                                       action: {
                                        onSelectImageLibrary()
                                       })
        )
        return buttons
    }
}
