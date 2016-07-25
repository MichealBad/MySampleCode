//
//  ViewController.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/22.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UITableViewController, ButtonHandleProtocol, HandleHeaderClick {
    
    var photos = [PhotoInfo]()
    var heightForPic = [CGFloat]()
    var heightForMessa = [CGFloat]()
    
    var indicatorFooter = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    var currentPage = 1
    var fecthingPhotos = false
    
    let statusBar = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerClass(AlbumView.self, forCellReuseIdentifier: "album")
        self.tableView.registerClass(PosterHeader.self, forHeaderFooterViewReuseIdentifier: "posterInfo")
        self.tableView.registerClass(MessaPostedView.self, forCellReuseIdentifier: "message")
        self.tableView.registerClass(OperationView.self, forCellReuseIdentifier: "operator")
        
        //print("\(UIScrollViewDecelerationRateFast) \(UIScrollViewDecelerationRateNormal)")
        //self.tableView.decelerationRate
        
        self.initTableFooter()
        self.startFecthingPhoto()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //print("home page appearing..animated:\(animated) navigation:\(self.navigationController)")
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        if let gradient = self.navigationController?.view.viewWithTag(125) {
            gradient.removeFromSuperview()
        }
        
        if let navigationBar = self.navigationController?.navigationBar {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
            
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:kRMCommonTextColor]
            navigationBar.tintColor = kRMCommonTextColor
            
            navigationBar.subviews[0].alpha = 1
        }
        
        if let tabBarC = self.tabBarController {
            statusBar.frame = CGRectMake(0, 0, self.view.bounds.width, 20)
            statusBar.backgroundColor = UIColor.whiteColor()
            statusBar.layer.zPosition = 589
            statusBar.tag = 89
            tabBarC.view.addSubview(statusBar)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        //print("home page disapping..animated:\(animated) navigation:\(self.navigationController)")
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.photos.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let albumView = self.tableView.dequeueReusableCellWithIdentifier("album", forIndexPath: indexPath)
            albumView.selectionStyle = .None
            return albumView
        } else if indexPath.row == 1 {
            let messagView = self.tableView.dequeueReusableCellWithIdentifier("message", forIndexPath: indexPath)
            messagView.selectionStyle = .None
            return messagView
        } else {
            let operationView = self.tableView.dequeueReusableCellWithIdentifier("operator", forIndexPath: indexPath) as! OperationView
            operationView.delegate = self
            operationView.selectionStyle = .None
            return operationView
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("posterInfo") as! PosterHeader
        header.delegate = self
        return header
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let section = indexPath.section
        let photo = self.photos[section]
        
        if indexPath.row == 0 {
            if self.heightForPic[section] == -1 {
                //print("caclutingPicH")
                let height = CGFloat(photo.height / photo.width) * self.view.bounds.width
                self.heightForPic[section] = ceil(height)
            }
            
            return self.heightForPic[section]
        } else if indexPath.row == 1 {
            if self.heightForMessa[section] == -1 {
                //print("caclutingMesH")
                let font = UIFont.systemFontOfSize(15.0)
                let str = NSString(string: "@\(photo.username!): \(photo.desc!) #\(photo.category!)")
                
                let size = str.boundingRectWithSize(CGSizeMake(self.view.frame.size.width - 12.0, 1000), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
                self.heightForMessa[section] = ceil(size.height+12)
            }
            
            return self.heightForMessa[section]
        } else {
            return 48
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let photo = self.photos[indexPath.section]
        
        if indexPath.row == 0 {
            let imageCell = cell as! AlbumView
            imageCell.resizeImageView(withImage: NSURL(string: photo.url)!)
        } else if indexPath.row == 1 {
            let messaView = cell as! MessaPostedView
            messaView.backgroundColor = UIColor.whiteColor()
            let str = "@\(photo.username!): \(photo.desc!) #\(photo.category!)"
            messaView.setStr(str)
        } else {
            cell.contentView.backgroundColor = UIColor.whiteColor()
            let op = cell as! OperationView
            op.setNotes(photo.favoritesCount! + photo.votesCount!,commentPhotoID: photo.id)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let photo = self.photos[section]
        
        let posterHeader = view as! PosterHeader
        posterHeader.contentView.backgroundColor = UIColor.whiteColor()
        posterHeader.set(CGRectMake(0, 0, 0, 0), icon: photo.userPictureURL!, name: photo.username!, userID: photo.userID!, userName: photo.username!)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollingDown ? .Bottom : .Top, animated: true)
        }
    }
    
    var lastOffSet: CGFloat = 0.0
    var scrollingDown = false
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollingDown = lastOffSet - scrollView.contentOffset.y > 0 ? true : false
        lastOffSet = scrollView.contentOffset.y
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + 80  && fecthingPhotos == false {
            self.initTableFooter()
            self.startFecthingPhoto()
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
    
    func startFecthingPhoto() {
        let url = Five100px.Router.UserFriendPhotos(self.currentPage, Five100px.ImageSize.Large).URLRequest.URL
        let auth = AuthHeaderString().getAuthHeaderString(url, httpMethod: "GET", body: nil)
        
        self.fecthingPhotos = true
        Alamofire.request(.GET, url!, headers: ["Authorization":auth]).responseCollection({
            (data: Response<[PhotoInfo],NSError>) in
            if data.result.error == nil {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    let lastIndex = self.photos.count
                    
                    self.photos.appendContentsOf(data.result.value!)
                    
                    for _ in lastIndex..<self.photos.count {
                        //print("i=\(i)")
                        self.heightForPic.append(-1)
                        self.heightForMessa.append(-1)
                    }
                    
                    self.currentPage += 1
                    self.fecthingPhotos = false
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                        self.removeTableFooter()
                    }
                }
            }
        })
    }
    
    //MARK: - ButtonHandleProtocol
    func handleCommentBtn(photoID: Int) {
        let photoCommentsViewController = storyboard?.instantiateViewControllerWithIdentifier("PhotoComments") as? PhotoCommentsViewController
        photoCommentsViewController?.photoID = photoID
        self.navigationController?.pushViewController(photoCommentsViewController!, animated: true)
    }
    
    //MARK: - HandleHeaderClick
    func handleTitleClick(userID: Int, userName: String) {
        let userProfile = storyboard?.instantiateViewControllerWithIdentifier("PersonCollection") as? PersonCollectionViewController
        userProfile?.userID = userID
        userProfile!.userName = userName
        self.navigationController?.pushViewController(userProfile!, animated: true)
    }
    
}

