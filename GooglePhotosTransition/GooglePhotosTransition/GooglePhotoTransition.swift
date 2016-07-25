//
//  GooglePhotoTransition.swift
//  GooglePhotosTransition
//
//  Created by Michealbad on 16/2/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class GooglePhotoTransition: NSObject {
    
    internal var duration = 0.3
    
    internal enum GPTransitionMode: Int {
        case Present, Dismiss
    }
    
    internal var transitionMode: GPTransitionMode = .Present
}


extension GooglePhotoTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let contianerView = transitionContext.containerView()
        
        if self.transitionMode == .Present {
            let presentedCV = transitionContext.viewForKey(UITransitionContextToViewKey)
            let presentingVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ViewController
            
            let oo = ExtrameFrameAndInitialFinalPath(presentingVC,presentVC: presentedCV)
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = oo.2.CGPath
            presentedCV?.layer.mask = maskLayer
            
            presentedCV?.frame.origin.y = oo.0.origin.y - 100.0
            //presentedCV?.alpha = 0.5
            contianerView!.addSubview(presentedCV!)
            
            let maskView = UIView(frame: (presentedCV?.bounds)!)
            maskView.backgroundColor = presentingVC.btn?.backgroundColor
            maskView.alpha = 0.6
            presentedCV?.addSubview(maskView)
            
            UIView.animateWithDuration(duration, animations: {
                let maskLayerAnimation = CABasicAnimation(keyPath: "path")
                maskLayerAnimation.fromValue = oo.1.CGPath
                maskLayerAnimation.toValue = oo.2.CGPath
                maskLayerAnimation.duration = self.duration
                maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
                
                presentedCV?.frame.origin.y = 0
                maskView.alpha = 0.0
                }, completion: {
                    _ in
                    let wasCancelled = transitionContext.transitionWasCancelled()
                    maskView.removeFromSuperview()
                    presentedCV?.layer.mask = nil
                    transitionContext.completeTransition(!wasCancelled)
                }
            )
        } else {
            let dismissingCV = transitionContext.viewForKey(UITransitionContextFromViewKey)
            let presentedVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ViewController
            
            let oo = ExtrameFrameAndInitialFinalPath(presentedVC, presentVC: dismissingCV)
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = oo.1.CGPath
            dismissingCV?.layer.mask = maskLayer
            
            UIView.animateWithDuration(duration, animations: {
                let maskLayerAnimation = CABasicAnimation(keyPath: "path")
                maskLayerAnimation.fromValue = oo.2.CGPath
                maskLayerAnimation.toValue = oo.1.CGPath
                
                maskLayerAnimation.duration = self.duration
                maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
                
                dismissingCV?.frame.origin.y = oo.0.origin.y - 100.0
                }, completion: {
                    _ in
                    let wasCancelled = transitionContext.transitionWasCancelled()
                    if wasCancelled == false { dismissingCV?.removeFromSuperview() }
                    dismissingCV?.layer.mask = nil
                    transitionContext.completeTransition(!wasCancelled)
                }
            )
        }
    }
    
    func ExtrameFrameAndInitialFinalPath(btnVC: UIViewController, presentVC: UIView?) -> (CGRect,UIBezierPath,UIBezierPath) {
        let btnFrame = (btnVC as! ViewController).btn?.frame
        var extrameFrame = btnFrame
        extrameFrame?.origin.y = 100.0
        
        let initialPath = UIBezierPath(ovalInRect: extrameFrame!)
        //let extramePoint = CGPointMake(extrameFrame!.origin.x - 0, extrameFrame!.origin.y - CGRectGetHeight((presentedCV?.bounds)!))
        //let radius = sqrt(extramePoint.x * extramePoint.x + extramePoint.y * extramePoint.y)
        let radius = sqrt(CGRectGetHeight((presentVC?.bounds)!)*CGRectGetHeight((presentVC?.bounds)!) +
            CGRectGetWidth((presentVC?.bounds)!)*CGRectGetWidth((presentVC?.bounds)!))
        let finalPath = UIBezierPath(ovalInRect: CGRectInset(extrameFrame!, -radius, -radius))
        return (btnFrame!,initialPath,finalPath)
    }
}

extension GooglePhotoTransition {
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
    }
}
