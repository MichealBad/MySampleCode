//
//  TimeLineHeaderReusableView.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/30.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class TimeLineHeaderReusableView: UICollectionReusableView {
    
    var timeLine: UILabel?
    var numOfItems = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.timeLine = UILabel()
        self.addSubview(timeLine!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(timeLine: String, num: Int, withColor color: UIColor) {
        
        self.timeLine!.frame = CGRect(x: 14, y: 0, width: 200, height: self.bounds.height)
        self.timeLine?.font = UIFont.systemFontOfSize(14)
        self.timeLine?.textColor = color
        self.timeLine!.text = "\(timeLine) \(num)Posts"

    }
    
        
}
