//
//  CollectionViewCell.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/31.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        let width  = self.bounds.width
        let height = self.bounds.height
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, width, height))
        self.imageView?.contentMode = .ScaleToFill
        self.addSubview(imageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(imageURL url: NSURL) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        self.imageView?.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: [.BackgroundDecode,.CallbackDispatchQueue(queue)], progressBlock: nil, completionHandler: nil)
    }
    
}
