//
//  SORAFileManager.swift
//  SORAPhotoPicker
//
//  Created by codediary on 9/6/21.
//

import Foundation

class SORAFileManager {
    static func copyToTempDirectory(fileURL: URL) -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        guard let cacheFolder = paths.first else {return nil}
        var targetURL = URL(fileURLWithPath: cacheFolder)
        targetURL.appendPathComponent(fileURL.lastPathComponent)
        do {
            if FileManager.default.fileExists(atPath: targetURL.path) {
                try FileManager.default.removeItem(at: targetURL)
            }
            try FileManager.default.copyItem(at: fileURL, to: targetURL)
        } catch {
            print("Exception:\(error)")
            return nil
        }
        return targetURL
    }
}


