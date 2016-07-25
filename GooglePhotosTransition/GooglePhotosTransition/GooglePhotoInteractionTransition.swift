//
//  GooglePhotoInteractionTransition.swift
//  GooglePhotosTransition
//
//  Created by Michealbad on 16/2/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class GooglePhotoInteractionTransition: UIPercentDrivenInteractiveTransition {
    
    var interactionGesture: UIPanGestureRecognizer?
    var transitionContext: UIViewControllerContextTransitioning?
    
    init(gestureRecognizer: UIPanGestureRecognizer) {
        self.interactionGesture = gestureRecognizer
        
        super.init()
        
        self.interactionGesture?.addTarget(self, action: Selector("gestureUpdateProcess:"))
    }
    
    override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        super.startInteractiveTransition(transitionContext)
    }
    
    func gestureUpdateProcess(gesture: UIPanGestureRecognizer) {
        let containerView = self.transitionContext?.containerView()
        let processLength = CGRectGetHeight((containerView?.bounds)!)-80.0
        
        switch gesture.state {
        case .Began: print("pass began")
        case .Changed:
            let translationY = gesture.translationInView(containerView).y
            //print(translationY)
            self.updateInteractiveTransition(translationY/processLength)
        case .Ended:
            let translationY = gesture.translationInView(containerView).y
            if translationY/processLength > 0.4 {
                //print(translationY/CGRectGetHeight((containerView?.bounds)!))
                self.finishInteractiveTransition()
            } else {
                print(translationY/CGRectGetHeight((containerView?.bounds)!))
                self.cancelInteractiveTransition()
            }
        default:
            self.cancelInteractiveTransition()
        }
    }

}
