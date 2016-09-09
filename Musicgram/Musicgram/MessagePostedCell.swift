//
//  MessaPostedView.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class MessaPostedCell: UITableViewCell {
    
    var messaLabel: RMTouableLabel?
    var likeCounterLabel: UILabel?
    var photoNameLabel: UILabel?
    
    let photoNameSize: CGFloat = 20
    let counterSize: CGFloat = 30
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.photoNameLabel = UILabel()
        self.photoNameLabel?.textColor = kRMKeyTextColor
        self.photoNameLabel?.font = UIFont.systemFontOfSize(18.0)
        self.photoNameLabel?.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(photoNameLabel!)
        
        self.likeCounterLabel = UILabel()
        self.likeCounterLabel?.backgroundColor = UIColor.whiteColor()
        self.likeCounterLabel?.textColor = kRMCommonTextColor
        self.likeCounterLabel?.font = UIFont.systemFontOfSize(14, weight: 0.2)
        self.contentView.addSubview(likeCounterLabel!)
        
        self.messaLabel = RMTouableLabel()
        self.messaLabel?.backgroundColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.whiteColor()
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(messaLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resizeSubviews() {
        let width = self.contentView.bounds.width, height = self.contentView.bounds.height
        
        self.likeCounterLabel?.frame = CGRect(x: 11, y: 2, width: width - 6, height: counterSize).integral
        
        self.photoNameLabel?.frame = CGRect(x: 11, y: counterSize+2, width: width - 6, height: photoNameSize).integral
        
        self.messaLabel?.frame = CGRect(x: 6.0, y: photoNameSize + counterSize + 4.0, width: self.contentView.bounds.size.width - 12.0, height: height - photoNameSize - counterSize - 4.0).integral
    }
    
    func setPhotoStr(photo: PhotoInfo) {
        
        self.likeCounterLabel?.text = "\(photo.votesCount!) likes"
        
        self.photoNameLabel?.text = photo.name
        
        var str = String()
        if let desc = photo.desc {
            str = str + desc
        }
        if let category = photo.category {
            str = str + "#\(category)"
        }
        self.messaLabel?.setStr(str, withSize: (self.messaLabel?.bounds.size)!)
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
