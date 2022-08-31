//
//  PresentationController.swift
//  YandexDiskRelease
//
//  Created by MacPro on 24.08.2022.
//

import UIKit
import Foundation

class TransitionController: NSObject, UIViewControllerTransitioningDelegate {
        
    private let driver = TransitionDriver()
    
    //MARK: - PresentationController
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        driver.addGesture(to: presented)
        
        return BackgroundViewPresentationController(presentedViewController: presented, presenting: presenting ?? source)
    }
    
    //MARK: - Animations
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimation()
    }
    
    //MARK: - Swipe
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if driver.wantsInteractiveStart {
            return driver
        } else {
            return nil
        }
    }
}
