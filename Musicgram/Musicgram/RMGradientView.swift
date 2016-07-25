//
//  RMGradientView.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class RMGradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        let alphaGradientLayer = CAGradientLayer()
        let colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.9).CGColor,
                      UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor]
        alphaGradientLayer.colors = colors
        alphaGradientLayer.startPoint = CGPointMake(0, 0)
        alphaGradientLayer.endPoint = CGPointMake(0,1)
        alphaGradientLayer.frame = self.bounds
        self.layer.addSublayer(alphaGradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        print(context == nil)
        let locations: [CGFloat] = [0.0,0.4,1.0]
        let compents: [CGFloat] = [100.0/255.0,101.0/255.0,102.0/255.0,1.0,
                                   1,1,1,0.3,
                                   1,1,1,0.1]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColorComponents(colorSpace, compents, locations, 3)
        
        print(self.bounds)
        
        let startPoint = CGPointMake(0.5, 0),endPoint = CGPointMake(0.5, 160)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, .DrawsAfterEndLocation)
        CGContextRestoreGState(context)
    }*/

}
