//
//  MainViewModel.swift
//  YandexDiskRelease
//
//  Created by MacPro on 20.07.2022.
//

import Foundation

protocol viewModelProtocol {
    
    var files: [File] { get set }
    var filesDidChangedHandler: (([File]) -> Void)? { get set }
    
    func prepareFiles()
    func printt()
}

class MainViewModel: viewModelProtocol {
    
    var filesDidChangedHandler: (([File]) -> Void)?
    
    var files: [File] = [] {
        didSet {
            print("files did set", files.count)
            
            filesDidChangedHandler?(files)
        }
    }
    
    func prepareFiles() {
        ApiManager.shared.fetchFiles { (response) in
            guard let items = response.items else { return }
            for item in items {
                ApiManager.shared.loadImage(url: item.preview!) { (image) in
                    let file = File(image: image!, name: item.name!, size: String(item.size!))
                    self.files.append(file)
                    //self.applySnapshot()
                }
            }
        }
    }
    
    func printt() {
        print("print print print")
    }
    
    //массив файлов
    
    //функ запроса к апи на массив файлов
    
    //diskResponse to File
    
    
}
