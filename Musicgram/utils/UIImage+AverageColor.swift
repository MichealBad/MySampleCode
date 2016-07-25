//
//  UIImage+AverageColor.swift
//  Walls
//
//  Created by Michealbad on 16/5/22.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics

extension UIImage {
    func averageColor() -> UIColor? {
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rgba: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.alloc(4)
        let context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, CGBitmapInfo.ByteOrder32Big.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage)
        
        let alpha = CGFloat(rgba.advancedBy(3).memory) / 255.0
        if alpha > 0 {
            let multiplier = alpha / 255.0
            
            return UIColor(red: CGFloat(rgba.advancedBy(0).memory) * multiplier ,
                           green: CGFloat(rgba.advancedBy(1).memory) * multiplier ,
                           blue: CGFloat(rgba.advancedBy(2).memory) * multiplier ,
                           alpha: alpha)
        } else {
            return UIColor(red: CGFloat(rgba.advancedBy(0).memory),
                           green: CGFloat(rgba.advancedBy(1).memory),
                           blue: CGFloat(rgba.advancedBy(2).memory),
                           alpha: alpha)
        }
    }
    
    func deepenColor(removeS: CGFloat) -> UIColor? {
        let hsta = UnsafeMutablePointer<CGFloat>.alloc(4)
        if self.averageColor()!.getHue(hsta.advancedBy(0), saturation: hsta.advancedBy(1), brightness: hsta.advancedBy(2), alpha: hsta.advancedBy(3)) == true {
            return UIColor(hue: hsta.advancedBy(0).memory, saturation: min(hsta.advancedBy(1).memory + removeS,1.0), brightness: hsta.advancedBy(2).memory*0.6, alpha: hsta.advancedBy(3).memory)
        }
        return nil
    }
    
    func ligthenColor(removeH: CGFloat, removeS: CGFloat) -> UIColor? {
        let hsta = UnsafeMutablePointer<CGFloat>.alloc(4)
        if self.averageColor()!.getHue(hsta.advancedBy(0), saturation: hsta.advancedBy(1), brightness: hsta.advancedBy(2), alpha: hsta.advancedBy(3)) == true {
            return UIColor(hue: max(hsta.advancedBy(0).memory - removeH,0.0), saturation: min(hsta.advancedBy(1).memory + removeS,1.0), brightness: hsta.advancedBy(2).memory, alpha: hsta.advancedBy(3).memory)
        }
        return nil
    }
    
    func cropEqualScaleImageToSize(size: CGSize) -> UIImage {
        let scale = UIScreen.mainScreen().scale
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        var aspectFitSize = CGSizeZero
        if self.size.width != 0 && self.size.height != 0 {
            let rateWidth = size.width / self.size.width
            let rateHeight = size.height / self.size.height
            
            let rate = min(rateHeight, rateWidth)
            
            aspectFitSize = CGSizeMake(self.size.width * rate, self.size.height * rate)
        }
        
        self.drawInRect(CGRectMake(0, 0, aspectFitSize.width, aspectFitSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
















