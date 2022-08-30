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
        let fromVC = transitionContext.viewController(forKey: .from) as! DetailViewControllerDelegate
        
        let image = fromVC.transitionImage()
        let fromImageViewRect = absoluteImageFrameInPresentedView(image: image, forView: fromVC.view)
        
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
