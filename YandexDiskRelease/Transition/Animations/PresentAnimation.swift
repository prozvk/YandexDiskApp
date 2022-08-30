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
        let toVC = transitionContext.viewController(forKey: .to) as! DetailViewControllerDelegate
        toVC.view.alpha = 0
        containerView.addSubview(toVC.view)
        
        let image = toVC.transitionImage()

        let finalTransitionSize = absoluteImageFrameInPresentedView(image: image, forView: toVC.view)
        
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
    
    /// Calculates frame of image in forView
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
