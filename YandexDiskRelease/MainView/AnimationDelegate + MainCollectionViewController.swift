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
        /// Возвращает пикчу ровно на то же место относительно экрана
        return selectedCellImageRect
        
        /// Возвращает пикчу ровно на то же место относительно ячейки но изза реюза все ломается иногда
        //return selectedCellImageView!.convert(selectedCellImageView!.frame, to: self.view)
    }
}
