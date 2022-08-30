//
//  AuthDelegate + MainCollectionViewController.swift
//  YandexDiskRelease
//
//  Created by MacPro on 23.08.2022.
//

import Foundation

extension MainCollectionViewController: AuthViewControllerDelegate {
    
    func handleTokenChanged() {
        viewModel.prepareFiles()
    }
    
    func presentAuthViewController() {
        let requsetTokenViewController = AuthViewController()
        requsetTokenViewController.delegate = self
        requsetTokenViewController.modalPresentationStyle = .fullScreen
        present(requsetTokenViewController, animated: false, completion: nil)
        return
    }
}
