//
//  File.swift
//  YandexDiskRelease
//
//  Created by MacPro on 20.07.2022.
//

import Foundation
import UIKit

class File: Hashable {
    
    var id = UUID()
    var name: String
    var size: String
    var path: String
    
    let defaultImage = UIImage(systemName: "doc.text")!
    
    var preview: UIImage?
    var previewUrl: URL?
    
    var image: UIImage?
    var imageUrl: URL?
    
    var fileGetImage: (() -> Void)?
        
    init(previewUrl: URL?, name: String, size: String, path: String) {
        self.previewUrl = previewUrl
        self.name = name
        self.size = size
        self.path = path
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: File, rhs: File) -> Bool {
        return lhs.id == rhs.id
    }
}
