//
//  DiskResponse.swift
//  YandexDiskRelease
//
//  Created by MacPro on 19.07.2022.
//

import Foundation

struct DiskResponse: Codable {
    let items: [DiskFile]?
}

struct DiskFile: Codable {
    let name: String?
    let preview: String?
    let size: Int64?
    let type: String?
    let mime_type: String?
}
