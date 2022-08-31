//
//  DismissAnimation.swift
//  YandexDiskRelease
//
//  Created by MacPro on 25.08.2022.
//

import UIKit

class DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: Double = 0.35        
    private var transitionImageView: UIImageView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.viewController(forKey: .to) as! MainViewAnimationDelegate
        let fromVC = transitionContext.viewController(forKey: .from) as! DetailViewAnimationDelegate
        
        let image = fromVC.transitionImage()
        let fromImageViewRect = image.absoluteFrameInView(forView: fromVC.view)
        
        if transitionImageView == nil {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.frame = fromImageViewRect
            imageView.layer.cornerRadius = 0
            imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
            transitionImageView = imageView
            containerView.addSubview(imageView)
        }
        
        toView.hideTransitionView()
        
        fromVC.view.alpha = 0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [UIView.AnimationOptions.transitionCrossDissolve]) {
            self.transitionImageView?.frame = toView.transitionViewFrame()
            self.transitionImageView?.layer.cornerRadius = 25
        } completion: { _ in
            self.transitionImageView?.removeFromSuperview()
            self.transitionImageView = nil
            toView.showTranisitionView()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
