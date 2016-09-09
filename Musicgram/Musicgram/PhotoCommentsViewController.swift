//
//  PhotoCommentsViewController.swift
//  PhotosFall
//
//  Created by Michealbad on 15/11/5.
//  Copyright © 2015年 Michealbad. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class PhotoCommentsViewController: UITableViewController {
    var photoID: Int = 0
    var comments = [Comment]()
    
    var currentPage = 1
    var fecthingComment = false
    var indicatorFooter = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    // MARK: Life-Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        
        title = "Comments"
        
        self.initTableFooter()
        self.startFetchingComment()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let statusBar = self.tabBarController?.view.viewWithTag(89) {
            statusBar.removeFromSuperview()
        }
    }
    
    func pop() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func startFetchingComment(){
        
        self.fecthingComment = true
        
        Comment.fetchCommentsAsync(self.photoID) {
            comments in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                self.comments.appendContentsOf(comments)
                self.fecthingComment = false
                self.currentPage += 1
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    func initTableFooter() {
        self.indicatorFooter.frame = CGRectMake(0, 0, self.view.bounds.width, 44)
        //self.indicatorFooter.backgroundColor = UIColor.whiteColor()
        self.indicatorFooter.hidesWhenStopped = true
        self.indicatorFooter.startAnimating()
        self.tableView.tableFooterView = self.indicatorFooter
    }
    
    func removeTableFooter() {
        self.indicatorFooter.stopAnimating()
        self.tableView.tableFooterView = nil
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + 100  && fecthingComment == false {
            self.initTableFooter()
            self.startFetchingComment()
        }
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! PhotoCommentTableViewCell
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let comCell = cell as! PhotoCommentTableViewCell
        comCell.userFullnameLabel.text = self.comments[indexPath.row].userFullname
        comCell.commentLabel.text = self.comments[indexPath.row].commentBody
        
        let imageURL = NSURL(string: self.comments[indexPath.row].userPictureURL)
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        comCell.userImageView?.kf_setImageWithURL(imageURL!, placeholderImage: nil, optionsInfo: [.BackgroundDecode,.CallbackDispatchQueue(queue)], progressBlock: nil, completionHandler: nil)
    }
}

class PhotoCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userFullnameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 5.0
        userImageView.layer.masksToBounds = true
        
        commentLabel.numberOfLines = 0
    }
}
