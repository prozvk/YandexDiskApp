//
//  File.swift
//  YandexDiskRelease
//
//  Created by MacPro on 20.07.2022.
//

import Foundation
import UIKit

struct File: Hashable {
    
    var id = UUID()
    var image: UIImage?
    var imageUrl: String?
    var name: String
    var size: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: File, rhs: File) -> Bool {
        return lhs.id == rhs.id
    }
}
