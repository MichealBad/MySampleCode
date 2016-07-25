//
//  WPActivityIndicator.swift
//  WPAnimation
//
//  Created by Michealbad on 16/6/23.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class WPActivityIndicator: UIView {
    
    var isAnimating = false
    var circleNumber = 0
    var totalCircleNumber = 0
    var circleSize: CGFloat = 10.0
    var radius: CGFloat = 0
    var color: UIColor?
    var circleDelay: NSTimer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isAnimating = false
        self.totalCircleNumber = 8
        self.color = UIColor.whiteColor()
        //self.backgroundColor = UIColor.blueColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        
        if !isAnimating {
            self.isAnimating = true
            self.circleNumber = 0
            self.radius = min(self.bounds.width / 2.0, self.bounds.height / 2.0)
            self.circleSize = 2.0 * radius / 15.0
            self.circleDelay = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(nextCircle), userInfo: nil, repeats: true)
        }
        
    }
    
    func stopAnimating() {
        isAnimating = false
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
    func nextCircle() {
        
        if circleNumber < totalCircleNumber {
            circleNumber += 1
            let x = (self.bounds.width - circleSize) / 2.0, y = self.bounds.height - circleSize
            let circle = Circle(frame: CGRectMake(x, y, circleSize, circleSize))
            circle.color = self.color
            circle.backgroundColor = UIColor.clearColor()
            self.addSubview(circle)
            
            let circlePath = CGPathCreateMutable()
            CGPathMoveToPoint(circlePath, nil, self.bounds.width / 2.0, self.bounds.height - circleSize/2.0)
            CGPathAddArc(circlePath, nil, self.bounds.width / 2.0, self.bounds.height / 2.0, radius - circleSize/2.0, CGFloat(-M_PI_2*3), CGFloat(M_PI_2), false)
            
            let circleAnimation = CAKeyframeAnimation(keyPath: "position")
            circleAnimation.duration = 3.0
            circleAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.15, 0.80, 0.85, 0.20)
            circleAnimation.path = circlePath
            circleAnimation.calculationMode = kCAAnimationPaced
            circleAnimation.repeatCount = HUGE
            circle.layer.addAnimation(circleAnimation, forKey: "circleAnimation")
        } else {
            circleDelay?.invalidate()
        }
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}










