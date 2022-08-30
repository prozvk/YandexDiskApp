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
    
    var fileGetImage: ((File) -> Void)? { get set }
    
    var isPaginating: Bool { get set }
    
    func prepareFiles()
}

class MainViewModel: ViewModelProtocol {
    
    var filesDidChangedHandler: (() -> Void)?
    
    var fileGetImage: ((File) -> Void)?
    
    var files: [File] = [] {
        didSet {            
            filesDidChangedHandler?()
        }
    }
    
    var offset: Int {
        return files.count
    }
        
    var isPaginating = false
    
    func prepareFiles() {
        isPaginating = true
        ApiManager.shared.fetchFiles(offset: offset) { (response) in
            guard let items = response.items else { return }
            var newFiles = [File]()
            for item in items {
                
                let file = File(previewUrl: URL(string: item.preview ?? "") ?? nil, name: item.name!, size: String(item.size!), path: item.path)
                
                let url = item.preview
                let path = item.path

                if url != nil {
                    let nsUrl = NSURL(string: url!)

                    // Fetch previews
                    ImageCache.shared.load(nsUrl: nsUrl, file: file) { (fetchedFile, image) in
                        if let img = image, img != fetchedFile.preview {
                            file.preview = image
                            file.fileGetImage?()
                            
                            guard let fileBind = self.fileGetImage else { return }
                            fileBind(file)
                        }
                    }

                    // Fetch full images
                    ApiManager.shared.getUrlForDownloadingImage(path: path) { (url) in
                        file.imageUrl = URL(string: url!)

                        ImageCache.shared.load(nsUrl: file.imageUrl! as NSURL, file: file) { (fetchedFile, image) in
                            if let img = image, img != fetchedFile.image {
                                file.image = image
                                file.fileGetImage?()

                                guard let fileBind = self.fileGetImage else { return }
                                fileBind(file)
                            }
                        }
                    }
                }
                newFiles.append(file)
            }
            
            self.files.append(contentsOf: newFiles)
            self.isPaginating = false
        }
    }
}
