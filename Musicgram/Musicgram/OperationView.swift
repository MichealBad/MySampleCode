//
//  OperationView.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

@objc public protocol ButtonHandleProtocol {
    
    optional func handleLikeBtn()
    optional func handleCommentBtn(photoID: Int)
    optional func handleRepostBtn()
    optional func handleMoreBtn()
}

class OperationView: UITableViewCell {
    
    let kBtnWidth: CGFloat = 48.0
    let kBtnHeight: CGFloat = 48.0
    var likeBtn: UIButton?
    var commentBtn: UIButton?
    var repostBtn: UIButton?
    var moreBtn: UIButton?
    
    var commentPhotoID = 0
    var noteLabel: UILabel?
    
    var delegate: ButtonHandleProtocol?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let width = self.frame.size.width
        
        self.likeBtn = UIButton(frame: CGRectIntegral(CGRectMake(width - kBtnWidth, 0, kBtnWidth, kBtnHeight)))
        self.likeBtn?.setImage(UIImage(named: "btn_like"), forState: .Normal)
        self.contentView.addSubview(likeBtn!)
        
        self.repostBtn = UIButton(frame: CGRectIntegral(CGRectMake(width - 2*kBtnWidth, 0, kBtnWidth, kBtnHeight)))
        self.repostBtn?.setImage(UIImage(named: "btn_repost"), forState: .Normal)
        self.contentView.addSubview(repostBtn!)
        
        self.commentBtn = UIButton(frame: CGRectIntegral(CGRectMake(width - 3*kBtnWidth, 0, kBtnWidth, kBtnHeight)))
        self.commentBtn?.setImage(UIImage(named: "btn_comment"), forState: .Normal)
        self.commentBtn?.addTarget(self, action: #selector(handleCommentBtn), forControlEvents: .TouchUpInside)
        self.contentView.addSubview(commentBtn!)
        
        self.moreBtn = UIButton(frame: CGRectIntegral(CGRectMake(width - 4*kBtnWidth, 0, kBtnWidth, kBtnHeight)))
        self.moreBtn?.setImage(UIImage(named: "btn_more"), forState: .Normal)
        self.contentView.addSubview(moreBtn!)
        
        self.noteLabel = UILabel(frame: CGRectIntegral(CGRectMake(11.0, 0, width - 4*kBtnWidth - 11.0, kBtnHeight)))
        self.noteLabel?.backgroundColor = UIColor.whiteColor()
        self.noteLabel?.textColor = kRMCommonTextColor
        self.noteLabel?.text = ""
        self.contentView.addSubview(self.noteLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNotes(notes: Int, commentPhotoID: Int) {
        self.noteLabel?.text = "\(notes) notes"
        self.commentPhotoID = commentPhotoID
    }
    
    func handleCommentBtn(sender: AnyObject) {
        if let delegate = self.delegate {
            print(commentPhotoID)
            delegate.handleCommentBtn!(commentPhotoID)
        }
    }

}
