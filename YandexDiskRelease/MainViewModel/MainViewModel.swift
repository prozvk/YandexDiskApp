//
//  MainViewModel.swift
//  YandexDiskRelease
//
//  Created by MacPro on 20.07.2022.
//

import Foundation
import UIKit

protocol ViewModelProtocol {
    
    var files: [File] { get set }
    var filesDidChangedHandler: (() -> Void)? { get set }
    var isPaginating: Bool { get set }
    
    func prepareFiles()
    
    func presentAuthViewController()
}

class MainViewModel: ViewModelProtocol {
    
    var navigationController: UINavigationController?
    
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    var filesDidChangedHandler: (() -> Void)?
    
    var files: [File] = [] {
        didSet {            
            filesDidChangedHandler?()
        }
    }
    
    
//    var offset: Int {
//        return files.count
//    }
    
    var offset = 0
    
    var isPaginating = false
    
    func prepareFiles() {
        isPaginating = true
        ApiManager.shared.fetchFiles(offset: offset) { (response) in
            guard let items = response.items else { return }
            let startCount = self.files.count
            print("START COUNT", self.files.count)
            print("КОЛИЧЕСТВО ПРИШЕДШИХ items", items.count)
            for item in items {
                if let preview = item.preview {
                    ApiManager.shared.loadImage(url: preview) { (image) in
                        let file = File(image: image, name: item.name!, size: String(item.size!))
                        self.files.append(file)
                    }
                } else {
                    let file = File(image: nil, name: item.name!, size: String(item.size!))
                    self.files.append(file)
                }
            }
            let newFiles = [File]()
            self.files.append(contentsOf: newFiles)
            print(self.files.count - startCount, "ФАЙЛОВ БЫЛО ДОБАВЛЕНО")
            
            self.offset += items.count
            print("offset", self.offset)
            self.isPaginating = false
        }
    }
}

extension MainViewModel: AuthViewControllerDelegate {
    
    func handleTokenChanged() {
        prepareFiles()
    }
    
    func presentAuthViewController() {
        let requsetTokenViewController = AuthViewController()
        requsetTokenViewController.delegate = self
        requsetTokenViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(requsetTokenViewController, animated: false, completion: nil)
        return
    }
}
