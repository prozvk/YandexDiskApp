//
//  ImageSaver.swift
//  YandexDiskRelease
//
//  Created by MacPro on 29.08.2022.
//

import UIKit

class ImageSaver {
    
    func save(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
