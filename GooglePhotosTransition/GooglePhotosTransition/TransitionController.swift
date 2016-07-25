//
//  TransitionController.swift
//  GooglePhotosTransition
//
//  Created by Michealbad on 16/2/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class TransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    var GPAnimator = GooglePhotoTransition()
    var gestureRecognizer: UIPanGestureRecognizer?

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.GPAnimator.transitionMode = .Present
        return GooglePhotoTransition()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.GPAnimator.transitionMode = .Dismiss
        return self.GPAnimator
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let gesture = self.gestureRecognizer {
            return GooglePhotoInteractionTransition(gestureRecognizer: gesture)
        }
        return nil
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
}
