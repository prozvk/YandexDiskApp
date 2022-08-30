//
//  DetailViewModel.swift
//  YandexDiskRelease
//
//  Created by MacPro on 21.08.2022.
//

import UIKit

protocol DetailViewModelProtocol {
    
    var imageBind: ((UIImage) -> ())? { get set }
    
    func writeToPhotos(image: UIImage)
}

class DetailViewModel: DetailViewModelProtocol {
    
    func writeToPhotos(image: UIImage) {
        
    }
    
    var file: File
    
    var imageBind: ((UIImage) -> ())?
    
    init(file: File) {
        self.file = file
        
        guard let image = file.image else {
            imageBind?(file.preview ?? file.defaultImage!)
            file.fileGetImage = { [weak self] in
                self?.imageBind?(file.image!)
            }
            return
        }
        imageBind?(image)
    }
}
