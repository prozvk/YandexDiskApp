//
//  TransitionDriver.swift
//  YandexDiskRelease
//
//  Created by MacPro on 26.08.2022.
//

import UIKit

class TransitionDriver: NSObject, UIViewControllerInteractiveTransitioning {
    
    private weak var presentedController: UIViewController?
    private var panRecognizer: UIPanGestureRecognizer?
    
    var wantsInteractiveStart: Bool = false
    
    private var transitionImage: UIImage?
    private var fromImageViewFrame: CGRect?
    private var toImageViewFrame: CGRect?
    private var transitionImageView: UIImageView?
    private var transitionContext: UIViewControllerContextTransitioning?
    
    private var toVC: MainViewAnimationDelegate?
    private var fromVC: DetailViewAnimationDelegate?
        
    func addGesture(to contoller: UIViewController) {
        presentedController = contoller
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(gestureRecognizer:)))
        presentedController?.view.addGestureRecognizer(panRecognizer!)
    }
        
    @objc private func handleDismiss(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            wantsInteractiveStart = true
            presentedController?.dismiss(animated: true, completion: nil)
        case .ended:
            endInteractiveTransition(gestureRecognizer: gestureRecognizer)
        default:
            handleDismissGesture(gestureRecognizer: gestureRecognizer)
        }
    }
    
    func handleDismissGesture(gestureRecognizer: UIPanGestureRecognizer) {
        
        let anchorPoint = CGPoint(x: fromImageViewFrame!.midX, y: fromImageViewFrame!.midY)
        
        let width = fromImageViewFrame!.width
        let height = fromImageViewFrame!.height
        
        //translate gR in imageview
        let translation = gestureRecognizer.translation(in: fromVC!.view)
        let verticalDelta : CGFloat = translation.y < 0 ? 0 : translation.y

        let scale = scaleFor(view: fromVC!.view, withPanningVerticalDelta: verticalDelta)
        
        let newCenter = CGPoint(x: anchorPoint.x + translation.x,
                                y: anchorPoint.y + translation.y - transitionImageView!.frame.height * (1 - scale) / 2)
        
        transitionImageView?.layer.cornerRadius = 50 - (50 * scale) // from 0 to 25
        transitionImageView!.frame.size.width = width * scale
        transitionImageView!.frame.size.height = height * scale
        transitionImageView?.center = newCenter
        fromVC!.view.alpha = scale
        
        transitionContext!.updateInteractiveTransition(1 - scale)
    }
    
    func scaleFor(view: UIView, withPanningVerticalDelta verticalDelta: CGFloat) -> CGFloat {
        let startingScale:CGFloat = 1.0
        let finalScale: CGFloat = 0.5
        let totalAvailableScale = startingScale - finalScale
        
        let maximumDelta = view.bounds.height / 2.0
        let deltaAsPercentageOfMaximun = min(abs(verticalDelta) / maximumDelta, 1.0)
        
        return startingScale - (deltaAsPercentageOfMaximun * totalAvailableScale)
    }
    
    func endInteractiveTransition(gestureRecognizer: UIPanGestureRecognizer) {
        
        let velocity = gestureRecognizer.velocity(in: fromVC!.view)
         
        let shouldComplete = velocity.y >= 0 || transitionImageView!.center.y >= fromImageViewFrame!.midY
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [UIView.AnimationOptions.transitionCrossDissolve]) {
            self.fromVC!.view.alpha = shouldComplete ? 0 : 1
            self.transitionImageView?.frame = shouldComplete ? self.toImageViewFrame! : self.fromImageViewFrame!
            self.transitionImageView?.layer.cornerRadius = shouldComplete ? 25 : 0
        } completion: { _ in
            self.toVC!.showTranisitionView()
            self.fromVC!.showTranisitionView()
            self.transitionImageView?.removeFromSuperview()
            self.transitionImageView = nil
            self.wantsInteractiveStart = false
            if !shouldComplete { self.transitionContext?.cancelInteractiveTransition() }
            self.transitionContext!.completeTransition(!self.transitionContext!.transitionWasCancelled)
        }        
    }
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        fromVC = transitionContext.viewController(forKey: .from) as? DetailViewAnimationDelegate
        toVC = transitionContext.viewController(forKey: .to) as? MainViewAnimationDelegate
        
        transitionImage = fromVC!.transitionImage()
        
        fromImageViewFrame = fromVC!.transitionViewFrame()
        
        toImageViewFrame = toVC!.transitionViewFrame()
                            
        if transitionImageView == nil {
            let imageView = UIImageView(image: transitionImage!)
            imageView.contentMode = .scaleAspectFill
            imageView.frame = fromImageViewFrame!
            imageView.layer.cornerRadius = 0
            imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
            transitionImageView = imageView
            transitionContext.containerView.addSubview(imageView)
        }
                
        toVC!.hideTransitionView()
        fromVC!.hideTransitionView()
    }
}
