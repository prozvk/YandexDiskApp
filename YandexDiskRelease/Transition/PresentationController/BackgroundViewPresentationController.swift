//
//  BackgroundViewPresentationController.swift
//  YandexDiskRelease
//
//  Created by MacPro on 25.08.2022.
//

import UIKit

class BackgroundViewPresentationController: PresentationController {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .white
        return view
    }()
    
    private func performDuringTransitioin(completion: @escaping () -> ()) {
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else {
            completion()
            return
        }
        
        transitionCoordinator.animate { (_) in
            completion()
        }
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        containerView!.insertSubview(backgroundView, at: 0)
        
        performDuringTransitioin {
            self.backgroundView.alpha = 1
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        backgroundView.frame = containerView!.frame
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if !completed {
            backgroundView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        performDuringTransitioin {
            self.backgroundView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            backgroundView.removeFromSuperview()
        }
    }
}
