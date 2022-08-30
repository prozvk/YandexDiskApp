//
//  ImageCache.swift
//  YandexDiskRelease
//
//  Created by MacPro on 29.07.2022.
//

import UIKit
public class ImageCache {
    
    public static let shared = ImageCache()
    var placeholderImage = UIImage(systemName: "doc.text")!
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(File, UIImage?) -> Swift.Void]]()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    final func load(nsUrl: NSURL?, file: File, completion: @escaping (File, UIImage?) -> Swift.Void) {
        guard let nsUrl = nsUrl else {
            completion(file, nil)
            return
        }
        
        if let cachedImage = image(url: nsUrl) {
            DispatchQueue.main.async {
                completion(file, cachedImage)
            }
            return
        }
        
        if loadingResponses[nsUrl] != nil {
            loadingResponses[nsUrl]?.append(completion)
            return
        } else {
            loadingResponses[nsUrl] = [completion]
        }
                            
        ApiManager.shared.loadImage(url: nsUrl as URL) { image in
            guard let image = image, let blocks = self.loadingResponses[nsUrl] else {
                DispatchQueue.main.async {
                    completion(file, nil)
                }
                return
            }
            self.cachedImages.setObject(image, forKey: nsUrl)
            
            for block in blocks {
                DispatchQueue.main.async {
                    block(file, image)
                }
                return
            }
        }
    }
}
