//
//  MessaPostedView.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class MessaPostedView: UITableViewCell {
    
    var messaLabel: RMTouableLabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.messaLabel = RMTouableLabel(frame: self.contentView.bounds)
        self.messaLabel?.backgroundColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(messaLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStr(Astring: String) {
        self.messaLabel?.frame = CGRectIntegral(CGRectMake(6.0, 6.0, self.contentView.bounds.size.width - 12.0, self.contentView.bounds.size.height - 12.0))
        self.messaLabel?.setStr(Astring, withSize: (self.messaLabel?.bounds.size)!)
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
