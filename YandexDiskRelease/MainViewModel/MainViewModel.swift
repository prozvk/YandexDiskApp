//
//  MainViewModel.swift
//  YandexDiskRelease
//
//  Created by MacPro on 20.07.2022.
//

import Foundation

protocol ViewModelProtocol {
    
    var files: [File] { get set }
    var filesDidChangedHandler: (() -> Void)? { get set }
    
    func prepareFiles()
}

class MainViewModel: ViewModelProtocol {
    
    var filesDidChangedHandler: (() -> Void)?
    
    var files: [File] = [] {
        didSet {
            print("files did set", files.count)
            
            filesDidChangedHandler?()
        }
    }
    
    func prepareFiles() {
        ApiManager.shared.fetchFiles { (response) in
            guard let items = response.items else { return }
            for item in items {
                ApiManager.shared.loadImage(url: item.preview!) { (image) in
                    let file = File(image: image!, name: item.name!, size: String(item.size!))
                    self.files.append(file)
                }
            }
        }
    }
}
