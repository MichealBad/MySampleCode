//
//  ToolsView.swift
//  Musicgram
//
//  Created by Michealbad on 16/8/31.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

@objc protocol ToolHandleDelegate {
    func cancelBtnDidClick()
    func continueBtnDidClick()
}

class ToolsView: UIView {
    
    weak var delegate: ToolHandleDelegate?
    
    let kLabelSize: CGFloat = 40
    var cancelBtn: UIButton!
    var continueBtn: UIButton!
    var titleLabel: UILabel!
    var detailImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        let btnFont = UIFont.systemFontOfSize(16)
        
        cancelBtn = UIButton(frame: CGRectMake(0, 0, 50, kLabelSize))
        cancelBtn.titleLabel?.font = btnFont
        cancelBtn.setTitleColor(kRMCommonTextColor, forState: .Normal)
        cancelBtn.setTitle("取消", forState: .Normal)
        cancelBtn.addTarget(self, action: #selector(didClickCancel), forControlEvents: .TouchUpInside)
        self.addSubview(cancelBtn)
        
        continueBtn = UIButton(frame: CGRectMake(frame.width - 50, 0, 50, kLabelSize))
        continueBtn.titleLabel?.font = btnFont
        continueBtn.setTitleColor(kRMKeyTextColor, forState: .Normal)
        continueBtn.setTitle("继续", forState: .Normal)
        continueBtn.addTarget(self, action: #selector(didClickContinue), forControlEvents: .TouchUpInside)
        self.addSubview(continueBtn)
        
        titleLabel = UILabel(frame: CGRectMake((frame.width-200.0)/2.0, 0, 200, kLabelSize))
        titleLabel.textAlignment = .Center
        titleLabel.font = btnFont
        self.addSubview(titleLabel)
        
        detailImageView = UIImageView(frame: CGRectMake(-1, kLabelSize-1, frame.width+2, frame.height-kLabelSize))
        detailImageView.layer.borderWidth = 1
        detailImageView.layer.borderColor = UIColor.whiteColor().CGColor
        detailImageView.contentMode = .ScaleToFill
        self.addSubview(detailImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(newTitle: String) {
        self.titleLabel.text = newTitle
    }
    
    func setImage(image: UIImage) {
        self.detailImageView.image = image
    }
    
    func didClickCancel() {
        if let delegate = self.delegate {
            delegate.cancelBtnDidClick()
        }
    }
    
    func didClickContinue() {
        if let delegate = self.delegate {
            delegate.continueBtnDidClick()
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
