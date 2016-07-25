//
//  PosterHeader.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol HandleHeaderClick {
    optional func handleTitleClick(userID: Int, userName: String)
}

class PosterHeader: UITableViewHeaderFooterView {
    
    var iconImageView: UIImageView!
    var posterNameLabel: UILabel!
    
    let kIconSize: CGFloat = 40
    let kNameTextSize: CGFloat = 30
    
    var userID: Int? = 0
    var userName: String?
    var delegate: HandleHeaderClick?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.iconImageView = UIImageView()
        self.iconImageView.contentMode = .ScaleAspectFit
        self.iconImageView.layer.masksToBounds = true
        self.iconImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTitleClick(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.iconImageView.addGestureRecognizer(tap)
        self.contentView.addSubview(iconImageView)
        
        self.posterNameLabel = UILabel()
        self.posterNameLabel.backgroundColor = UIColor.whiteColor()
        self.posterNameLabel.textColor = kRMCommonTextColor
        self.posterNameLabel.font = UIFont.systemFontOfSize(14, weight: 0.25)
        self.contentView.addSubview(posterNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(frame: CGRect, icon: String, name: String, userID: Int, userName: String) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        self.iconImageView.kf_setImageWithURL(NSURL(string: icon)!, placeholderImage: nil, optionsInfo: [.BackgroundDecode,.CallbackDispatchQueue(queue)], progressBlock: nil, completionHandler: nil)
        
        let kHalfSpace = ceil((self.frame.size.height - kIconSize) / 2.0)
        self.iconImageView.frame = CGRectIntegral(CGRectMake(kHalfSpace,kHalfSpace,kIconSize,kIconSize))
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height / 2.0
        
        let kNameLabelX = ceil(kHalfSpace * 2.0 + kIconSize)
        let kNameLabelY = ceil((self.frame.size.height - kNameTextSize) / 2.0)
        self.posterNameLabel.frame = CGRectMake(kNameLabelX,kNameLabelY,200,kNameTextSize)
        self.posterNameLabel.text = name
        
        self.userID = userID
        self.userName = userName
    }
    
    func handleTitleClick(sender: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.handleTitleClick!(self.userID!, userName: self.userName!)
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
