//
//  RMColorPicker.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/24.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class RMColorPicker: NSObject {
    
    var image: UIImage? = nil
    var avColor: UIColor? = nil
    
    init(image: UIImage) {
        self.image = image
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    func set(image: UIImage) {
        self.image = image
        avColor = nil
    }
    
    func averageColor() -> UIColor? {
        
        print(":i am bang!", terminator: "")
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rgba: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>(bitPattern: 4)
        
        let context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, CGBitmapInfo.ByteOrder32Big.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: 1, height: 1), self.image?.CGImage)
        
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
        
        self.avColor = (avColor == nil ? self.averageColor() : avColor)
        
        let hsta = UnsafeMutablePointer<CGFloat>(bitPattern: 4)
        if self.avColor?.getHue(hsta.advancedBy(0), saturation: hsta.advancedBy(1), brightness: hsta.advancedBy(2), alpha: hsta.advancedBy(3)) == true {
            return UIColor(hue: hsta.advancedBy(0).memory, saturation: min(hsta.advancedBy(1).memory + removeS,1.0), brightness: hsta.advancedBy(2).memory*0.6, alpha: hsta.advancedBy(3).memory)
        }
        return nil
    }
    
    func ligthenColor(removeH: CGFloat, removeS: CGFloat) -> UIColor? {
        
        self.avColor = (avColor == nil ? self.averageColor() : avColor)
        
        let hsta = UnsafeMutablePointer<CGFloat>(bitPattern: 4)
        if self.avColor?.getHue(hsta.advancedBy(0), saturation: hsta.advancedBy(1), brightness: hsta.advancedBy(2), alpha: hsta.advancedBy(3)) == true {
            return UIColor(hue: max(hsta.advancedBy(0).memory - removeH,0.0), saturation: min(hsta.advancedBy(1).memory + removeS,1.0), brightness: hsta.advancedBy(2).memory, alpha: hsta.advancedBy(3).memory)
        }
        return nil
    }
    

}
