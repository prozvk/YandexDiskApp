//
//  DetailViewControllerDelegate + DetailViewController.swift
//  YandexDiskRelease
//
//  Created by MacPro on 29.08.2022.
//

import UIKit

extension DetailView: DetailViewControllerDelegate {
    
    func hideTransitionView() {
        imageView.isHidden = true
    }
    
    func showTranisitionView() {
        imageView.isHidden = false
    }
    
    func transitionViewFrame() -> CGRect {
        return absoluteImageFrameInPresentedView(image: imageView.image!, forView: view)
    }
    
    func transitionImage() -> UIImage {
        return imageView.image!
    }
    
    private func absoluteImageFrameInPresentedView(image: UIImage, forView view: UIView) -> CGRect {
        
        let viewRatio = view.frame.size.width / view.frame.size.height
        let imageRatio = image.size.width / image.size.height
        
        let touchesSides = (imageRatio > viewRatio)
        
        if touchesSides {
            let height = view.frame.width / imageRatio
            let yPoint = view.frame.minY + (view.frame.height - height) / 2
            return CGRect(x: 0, y: yPoint, width: view.frame.width, height: height)
        } else {
            let width = view.frame.height * imageRatio
            let xPoint = view.frame.minX + (view.frame.width - width) / 2
            return CGRect(x: xPoint, y: 0, width: width, height: view.frame.height)
        }
    }
}
