//
//  DetailViewModel.swift
//  YandexDiskRelease
//
//  Created by MacPro on 21.08.2022.
//

import UIKit

protocol DetailViewModelProtocol: class {
    
    var imageBind: ((UIImage) -> ())? { get set }
    
    func writeToPhotos(image: UIImage)
}

class DetailViewModel: DetailViewModelProtocol {
    
    var file: File
    
    var imageBind: ((UIImage) -> ())? {
        didSet {
            imageBind!((file.image ?? file.preview) ?? file.defaultImage)
        }
    }
    
    init(file: File) {
        self.file = file
        
        fileImageListener()
    }
    
    func fileImageListener() {
        file.fileGetImage = { [weak self] in
            self?.imageBind?(self!.file.image!)
        }
    }
    
    func writeToPhotos(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
}
