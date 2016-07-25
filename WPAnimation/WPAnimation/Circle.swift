//
//  Circle.swift
//  WPAnimation
//
//  Created by Michealbad on 16/6/23.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class Circle: UIView {
    
    var color: UIColor? = UIColor.whiteColor()

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        self.color?.set()
        
        //CGContextFillEllipseInRect(context, self.frame)
        
        CGContextAddArc(context, self.frame.size.width / 2.0, self.frame.size.height / 2.0, self.frame.height/2.0 - 1, 0, CGFloat(2*M_PI), 1)
        
        CGContextDrawPath(context, .Fill)
        
    }

}
