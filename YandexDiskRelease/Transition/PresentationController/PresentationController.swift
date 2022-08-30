//
//  PresentationController.swift
//  YandexDiskRelease
//
//  Created by MacPro on 24.08.2022.
//

import UIKit

/// Класс отвечает за финальное отображение
class PresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView!.frame
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(presentedView!)
    }
    
    override func containerViewDidLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}

