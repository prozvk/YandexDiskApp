//
//  PresentAnimation.swift
//  YandexDiskRelease
//
//  Created by MacPro on 24.08.2022.
//

import UIKit

class PresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: Double = 0.45
    private var transitionImageView: UIImageView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let fromVC = transitionContext.viewController(forKey: .from) as! MainViewAnimationDelegate
        let toVC = transitionContext.viewController(forKey: .to) as! DetailViewAnimationDelegate
        toVC.view.alpha = 0
        containerView.addSubview(toVC.view)
        
        let image = toVC.transitionImage()

        let finalTransitionSize = image.absoluteFrameInView(forView: toVC.view)
        
        if transitionImageView == nil {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.frame = fromVC.transitionViewFrame()
            imageView.layer.cornerRadius = 25
            imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
            transitionImageView = imageView
            containerView.addSubview(imageView)
        }
        
        fromVC.hideTransitionView()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [UIView.AnimationOptions.transitionCrossDissolve]) {
            self.transitionImageView?.frame = finalTransitionSize
            self.transitionImageView?.layer.cornerRadius = 0
        } completion: { _ in
            toVC.view.alpha = 1.0
            self.transitionImageView?.removeFromSuperview()
            self.transitionImageView = nil
            fromVC.showTranisitionView()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
