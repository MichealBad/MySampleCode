//
//  IndicatorFooterReusableView.swift
//  Musicgram
//
//  Created by Michealbad on 16/6/8.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class IndicatorFooterReusableView: UICollectionReusableView {
    
    var indicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height)
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = UIColor.whiteColor()
        self.addSubview(indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func footerStartAnimating() {
        self.indicator.startAnimating()
    }
    
    func footerStopAnimating() {
        self.indicator.stopAnimating()
    }
        
}
