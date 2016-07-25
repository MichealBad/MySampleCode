//
//  PersonHeaderReusableView.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/30.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Kingfisher

class PersonHeaderReusableView: UICollectionReusableView {
    
    let kTitleSize: CGFloat = 80.0
    let kUserNameSize: CGFloat = 30.0
    let kBackSize: CGFloat = 175.0
    
    var title: UIImageView?
    var backgroundImage: UIImageView?
    var userNameLabel: UILabel?
    var userIntroLabel: UILabel?
    
    var timeLine: TimeLineHeaderReusableView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = self.bounds.width
        
        self.backgroundImage = UIImageView(frame: CGRectMake(0, 0, width, kBackSize))
        self.backgroundImage?.backgroundColor = UIColor(red: 56.0/255.0, green: 157.0/255.0, blue: 207.0/255.0, alpha: 1)
        //self.backgroundImage?.contentMode = .ScaleAspectFill
        self.addSubview(backgroundImage!)
        
        self.title = UIImageView(frame: CGRectMake(width/2.0 - kTitleSize/2.0, kBackSize - kTitleSize/2.0, kTitleSize, kTitleSize))
        self.title?.layer.borderWidth = 2
        self.title?.layer.borderColor = UIColor.whiteColor().CGColor
        self.title?.frame.origin.y -= 20
        self.addSubview(title!)
        
        self.userNameLabel = UILabel(frame: CGRectMake(0, kBackSize + 20, width, kUserNameSize))
        self.userNameLabel?.textAlignment = .Center
        self.userNameLabel?.font = UIFont.systemFontOfSize(24)
        self.addSubview(userNameLabel!)
        
        self.userIntroLabel = UILabel(frame: CGRectMake(0, kBackSize + kUserNameSize + 20, width, 0))
        self.userIntroLabel?.textAlignment = .Center
        self.userIntroLabel?.numberOfLines = 0
        self.userIntroLabel?.font = UIFont.systemFontOfSize(15)
        self.addSubview(userIntroLabel!)
        
        //self.timeLine = TimeLineHeaderReusableView(frame: CGRectMake(0, height-30, width, 30))
        //self.addSubview(timeLine!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title title: NSURL, userName: String, userIntro: String, backgroundImage: UIImage, withTextColor color: UIColor) {
        self.title?.kf_setImageWithURL(title)
        //self.backgroundImage?.image = backgroundImage
        
        self.userNameLabel?.textColor = color
        self.userNameLabel?.text = userName
        
        self.setUserIntroSize(userIntro, withColor: color)
        
        //self.timeLine?.set("2016-5-30", num: 4, withColor: color)
    }
    
    func setUserIntroSize(intro: String, withColor: UIColor) {
        let str = NSString(string: intro)
        let size = str.boundingRectWithSize(CGSizeMake(self.bounds.width, 1000), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil)
        self.userIntroLabel?.frame.size.height = size.size.height
        self.userIntroLabel?.text = intro
        self.userIntroLabel?.textColor = withColor
    }
        
}
