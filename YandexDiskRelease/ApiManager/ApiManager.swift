//
//  ApiManager.swift
//  YandexDiskRelease
//
//  Created by MacPro on 20.07.2022.
//

import Foundation
import UIKit

class ApiManager {
    
    static let shared = ApiManager()
    
    private init() {}
    
    var token: String! {
        return (UserDefaults.standard.value(forKey: "Token") as? String) ?? nil
    }
        
    func fetchFiles(offset: Int, completion: @escaping (DiskResponse) -> Void) {
        
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/files")
        //components?.queryItems = [URLQueryItem(name: "media_type", value: "image")]
        
        components?.queryItems = [URLQueryItem(name: "limit", value: "10"), URLQueryItem(name: "offset", value: "\(offset)")]
        
        guard let url = components?.url, (token != nil) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            guard let newFiles = try? JSONDecoder().decode(DiskResponse.self, from: data) else { return }
            
            guard newFiles.items != nil else {
                print("items == nil")
                return
            }
            
            //print("ПОЛУЧИЛИ \(newFiles.items?.count ?? 0) ОБЬЕКТОВ")
            
            DispatchQueue.main.async {
                completion(newFiles)
            }
        }
        task.resume()
    }
    
    func loadImage(url: String, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
        task.resume()
    }
}
