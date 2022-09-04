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
        
    func fetchFiles(offset: Int, completion: @escaping (DiskResponse?) -> Void) {
        
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/files")
        //components?.queryItems = [URLQueryItem(name: "media_type", value: "image")]
        
        components?.queryItems = [URLQueryItem(name: "limit", value: "20"), URLQueryItem(name: "offset", value: "\(offset)")]
        
        guard let url = components?.url, (token != nil) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            guard let newFiles = try? JSONDecoder().decode(DiskResponse.self, from: data) else { return }
            
            guard newFiles.items != nil else {
                print("items == nil")
                return
            }
                        
            DispatchQueue.main.async {
                completion(newFiles)
            }
        }
        task.resume()
    }
    
    func loadImage(url: URL, completion: @escaping ((UIImage?) -> Void)) {
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
    
    func getUrlForDownloadingImage(path: String, completion: @escaping ((String?) -> Void)) {
        
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/download")
        
        components?.queryItems = [URLQueryItem(name: "path", value: path)]
        
        var request = URLRequest(url: components!.url!)
        request.setValue("OAuth \(token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            guard let url = try? JSONDecoder().decode(UrlResponse.self, from: data) else { return }
            
            if error != nil {
                print(error?.localizedDescription as Any)
                fatalError()
            }
            
            DispatchQueue.main.async {
                completion(url.href)
            }
        }
        task.resume()
    }
}
