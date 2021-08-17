//
//  ImageSaver.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import UIKit

public class ImageSaver: NSObject {
    
    private let completion: (Error?) -> ()
    
    public init(completion: @escaping (Error?) -> ()) {
        self.completion = completion
    }
    
    public func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc public func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        completion(error)
    }
}

