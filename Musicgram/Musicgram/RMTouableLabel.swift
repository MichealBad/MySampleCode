//
//  RMTouableLabel.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class RMTouableLabel: UILabel {
    
    var textStorage: NSTextStorage?
    var textContainer: NSTextContainer?
    var layoutManager: NSLayoutManager?
    
    let kTextSize: CGFloat = 15.0
    
    let pattern = "@[a-z1-9_]*\\s|@[a-z1-9_]*|#[a-z1-9_]*\\s|#[a-z1-9_]*"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.numberOfLines = 1
        self.userInteractionEnabled = true
        
        self.textContainer = NSTextContainer()
        
        self.layoutManager = NSLayoutManager()
        self.layoutManager?.addTextContainer(textContainer!)
        
        self.textStorage = NSTextStorage()
        self.textStorage?.addLayoutManager(layoutManager!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStr(Astring: String, withSize size: CGSize) {
        self.attributedText = self.analysisString(Astring)
        
        self.textContainer?.size = size
        
        self.textStorage?.setAttributedString(self.attributedText!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let pos = touch?.locationInView(self)
        
        let glyphIndex = self.layoutManager?.glyphIndexForPoint(pos!, inTextContainer: self.textContainer!, fractionOfDistanceThroughGlyph: nil)
        let characterIndex = self.layoutManager?.characterIndexForGlyphAtIndex(glyphIndex!)
        
        print(characterIndex)
    }
    
    func analysisString(str: String) -> NSAttributedString? {
        let attributedStr = NSMutableAttributedString(string: str)
        attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(kTextSize), range: NSRange(location: 0, length: attributedStr.length))
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: kRMCommonTextColor, range: NSRange(location: 0, length: attributedStr.length))
        
        do {
            let regularExpression: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
            let result = regularExpression.matchesInString(str, options: NSMatchingOptions.WithTransparentBounds, range: NSMakeRange(0, attributedStr.length))
            for range in result {
                let matchRange = range.rangeAtIndex(0)
                attributedStr.addAttribute(NSForegroundColorAttributeName, value: kRMKeyTextColor, range: matchRange)
                //attributedStr.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: matchRange)
            }
        } catch let e {
            print(e)
        }
        
        return attributedStr
    }
    
    override func drawTextInRect(rect: CGRect) {
        //self.attributedText?.drawInRect(rect)
        
        let range = self.layoutManager?.glyphRangeForTextContainer(self.textContainer!)
        let point = CGPointZero
        
        self.layoutManager?.drawGlyphsForGlyphRange(range!, atPoint: point)
        self.layoutManager?.drawBackgroundForGlyphRange(range!, atPoint: point)
    }
    
    /*
    override func drawRect(rect: CGRect) {
        let range = self.layoutManager?.glyphRangeForTextContainer(self.textContainer!)
        self.layoutManager?.drawGlyphsForGlyphRange(range!, atPoint: CGPointZero)
        self.layoutManager?.drawBackgroundForGlyphRange(range!, atPoint: CGPointZero)
    }*/

}
