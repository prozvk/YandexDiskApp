//
//  AnimationDelegate.swift
//  YandexDiskRelease
//
//  Created by MacPro on 25.08.2022.
//

import UIKit

protocol MainViewAnimationDelegate: class {
    
    func hideTransitionView()
    
    func showTranisitionView()
    
    func transitionViewFrame() -> CGRect
}

protocol DetailViewAnimationDelegate: MainViewAnimationDelegate {
    
    var view: UIView! { get set }
    
    func transitionImage() -> UIImage
    
    func saveButtonView() -> UIView
}
