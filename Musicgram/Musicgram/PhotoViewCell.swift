//
//  AlbumViewTableViewCell.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class PhotoViewCell: UITableViewCell {
    
    var albumImageView: UIImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.addSubview(albumImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhoto(photo: PhotoInfo) {
        self.albumImageView.frame = self.contentView.bounds
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        self.albumImageView.kf_setImageWithURL(NSURL(string: photo.url)!, placeholderImage: nil, optionsInfo: [.BackgroundDecode,.CallbackDispatchQueue(queue)], progressBlock: nil, completionHandler: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
