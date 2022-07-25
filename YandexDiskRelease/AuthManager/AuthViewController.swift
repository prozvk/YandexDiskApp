//
//  AuthViewController.swift
//  YandexDiskRelease
//
//  Created by MacPro on 19.07.2022.
//

import Foundation
import WebKit

protocol AuthViewControllerDelegate: class {
    func handleTokenChanged(token: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let clientId = "555cc530676f4ca69e36c24f2fc9b179"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        guard let request = request else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private var request: URLRequest? {
        guard var urlComponents = URLComponents(string: "https://oauth.yandex.ru/authorize") else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "\(clientId)")]
        
        guard let url = urlComponents.url else { return nil }
        
        return URLRequest(url: url)
    }
}

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
                
        if let url = navigationAction.request.url , url.scheme == "myphotos"/*, url.scheme = scheme */ {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            let token = components.queryItems?.first(where: { $0.name == "access_token" })?.value
            
            if let token = token {
                UserDefaults.standard.set(token, forKey: "Token")
                delegate?.handleTokenChanged(token: token)
            }
            dismiss(animated: true, completion: nil)
        }
        decisionHandler(.allow)
    }
}
