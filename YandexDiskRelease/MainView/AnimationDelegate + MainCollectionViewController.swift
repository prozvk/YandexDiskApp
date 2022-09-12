//
//  AnimationDelegate + MainCollectionViewController.swift
//  YandexDiskRelease
//
//  Created by MacPro on 25.08.2022.
//

import UIKit

extension MainCollectionViewController: MainViewAnimationDelegate {
    
    func hideTransitionView() {
        selectedCellImageView?.isHidden = true
    }
    
    func showTranisitionView() {
        selectedCellImageView?.isHidden = false
    }
    
    func transitionViewFrame() -> CGRect {
        return selectedCellImageRect
        
        //return selectedCellImageView!.convert(selectedCellImageView!.frame, to: self.view)
    }
}
