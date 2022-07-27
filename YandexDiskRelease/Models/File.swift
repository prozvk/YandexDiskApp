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
    var name: String
    var size: String
}
