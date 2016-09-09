//
//  HeaderCammandCell.swift
//  Musicgram
//
//  Created by Michealbad on 16/8/21.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

@objc protocol CammandRequestDelegate {
    
    @objc optional func handleTitleClick(userID: Int, userName: String)
    @objc optional func handleLikeBtn()
    @objc optional func handleCommentBtn(photoID: Int)
    @objc optional func handleRepostBtn()
    @objc optional func handleMoreBtn()
    
}

class HeaderCammandCell: UITableViewCell {
    
    weak var delegate: CammandRequestDelegate?
    
    var iconImageView: UIImageView!
    var posterNameLabel: UILabel!
    var uploadedLabel: UILabel!
    var likeBtn: UIButton?
    var commentBtn: UIButton?
    var buttomLine: UIView!
    
    let kIconSize: CGFloat = 36
    let kNameTextSize: CGFloat = 20
    let kUploadedSize: CGFloat = 20
    let kBtnWidth: CGFloat = 48.0
    let kBtnHeight: CGFloat = 48.0
    
    var userID: Int? = 0
    var userName: String?
    var commentPhotoID = 0

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        self.iconImageView = UIImageView()
        self.iconImageView.contentMode = .ScaleAspectFit
        self.iconImageView.layer.masksToBounds = true
        self.iconImageView.userInteractionEnabled = true
        self.iconImageView.layer.cornerRadius = kIconSize / 2.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTitleClick(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.iconImageView.addGestureRecognizer(tap)
        self.contentView.addSubview(iconImageView)
        
        self.posterNameLabel = UILabel()
        self.posterNameLabel.backgroundColor = UIColor.whiteColor()
        self.posterNameLabel.textColor = kRMCommonTextColor
        self.posterNameLabel.font = UIFont.systemFontOfSize(14, weight: 0.2)
        self.contentView.addSubview(posterNameLabel)
        
        self.uploadedLabel = UILabel()
        self.uploadedLabel.backgroundColor = UIColor.whiteColor()
        self.uploadedLabel.textColor = kRMTitleTextColor
        self.uploadedLabel.font = UIFont.systemFontOfSize(12)
        self.contentView.addSubview(uploadedLabel)
        
        self.likeBtn = UIButton()
        self.likeBtn?.setImage(UIImage(named: "btn_like"), forState: UIControlState())
        self.contentView.addSubview(likeBtn!)
        
        self.commentBtn = UIButton()
        self.commentBtn?.setImage(UIImage(named: "btn_comment"), forState: UIControlState())
        self.commentBtn?.addTarget(self, action: #selector(handleCommentBtn), forControlEvents: .TouchUpInside)
        self.contentView.addSubview(commentBtn!)
        
        self.buttomLine = UIView()
        self.buttomLine.backgroundColor = UIColor.grayColor()
        self.buttomLine.alpha = 0.2
        self.contentView.addSubview(buttomLine)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resizeSubviews() {
        let width = self.frame.size.width, height = self.frame.size.height
        
        let kHalfSpace = ceil((height - kIconSize) / 2.0)
        self.iconImageView.frame = CGRect(x: kHalfSpace,y: kHalfSpace,width: kIconSize,height: kIconSize).integral
        
        let kNameLabelX = ceil(kHalfSpace * 2.0 + kIconSize)
        let textWidth = width - kNameLabelX - 2*kBtnWidth - 1
        self.posterNameLabel.frame = CGRect(x: kNameLabelX, y: 5, width: textWidth, height: kNameTextSize).integral
        
        self.uploadedLabel.frame = CGRect(x: kNameLabelX, y: kNameTextSize+5, width: textWidth, height: kUploadedSize).integral
        
        self.likeBtn?.frame = CGRect(x: width - kBtnWidth - 1, y: 1, width: kBtnWidth, height: kBtnHeight).integral
        
        self.commentBtn?.frame = CGRect(x: width - 2*kBtnWidth - 1, y: 1, width: kBtnWidth, height: kBtnHeight).integral
        
        self.buttomLine.frame = CGRect(x: 14, y: height - 1, width: width-28, height: 1).integral
    }
    
    func setUserPhoto(photo: PhotoInfo) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        self.iconImageView.kf_setImageWithURL(NSURL(string: photo.userPictureURL!)!, placeholderImage: nil, optionsInfo: [.BackgroundDecode,.CallbackDispatchQueue(queue)], progressBlock: nil, completionHandler: nil)
        
        self.userID = photo.userID
        self.userName = photo.username
        self.posterNameLabel.text = photo.fullname
        self.uploadedLabel.text = photo.uploaded
    }
    
    func handleTitleClick(sender: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.handleTitleClick!(self.userID!, userName: self.userName!)
        }
    }
    
    func handleCommentBtn(sender: AnyObject) {
        if let delegate = self.delegate {
            print(commentPhotoID, terminator: "")
            delegate.handleCommentBtn!(commentPhotoID)
        }
    }

}
