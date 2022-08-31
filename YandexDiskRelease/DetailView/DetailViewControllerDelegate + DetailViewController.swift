//
//  DetailViewControllerDelegate + DetailViewController.swift
//  YandexDiskRelease
//
//  Created by MacPro on 29.08.2022.
//

import UIKit

extension DetailView: DetailViewAnimationDelegate {
    
    func hideTransitionView() {
        imageView.isHidden = true
    }
    
    func showTranisitionView() {
        imageView.isHidden = false
    }
    
    func transitionViewFrame() -> CGRect {
        return imageView.image!.absoluteFrameInView(forView: view)
    }
    
    func transitionImage() -> UIImage {
        return imageView.image!
    }
}
