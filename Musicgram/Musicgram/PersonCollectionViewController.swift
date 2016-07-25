//
//  PersonCollectionViewController.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/30.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

private let reuseIdentifier = "PostCell"
private let reuseHeaderIdentifier = "HeaderPostCell"
private let reusePersonIdentifier = "PersonHeader"

class PersonCollectionViewController: UICollectionViewController {
    
    var singer = ["KODALINE","Foster_the_People","Ellie_Goulding","One_Republic","The_Strokes"]
    var song = ["In_a_Perfect_World","Supermodel","Halcyon_Days","Native","Comedown_Machine"]
    var songImage = [UIImage]()
    
    var userID: Int? = 14800033
    var userName: String? = "594178994"
    var user: User?
    
    var photos = [PhotoInfo]()
    var indicatorFooter = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var currentPage = 1
    var fecthingPhotos = false
    
    let kDefaultSize: CGFloat = 225.0
    var aboutSize: CGFloat = 125.0
    
    let myTag = arc4random()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.title = userName
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.subviews[0].alpha = 0
            
            let grandient = RMGradientView(frame: CGRectMake(0, 0, self.view.bounds.size.width, navigationBar.bounds.height + 30))
            grandient.tag = 125
            self.navigationController?.view.insertSubview(grandient, belowSubview: navigationBar)
            
            self.collectionView?.contentInset = UIEdgeInsetsMake(-(navigationBar.bounds.height+20), 0, 0, 0)
        }
        
        
        // Register cell classes
        self.collectionView?.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.registerClass(TimeLineHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        self.collectionView?.registerClass(PersonHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reusePersonIdentifier)
        self.collectionView?.registerClass(IndicatorFooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0.5
        layout.minimumLineSpacing = 1
        let size = ((self.collectionView?.bounds.width)! - 2.0) / 3.0
        layout.itemSize = CGSizeMake(size, size)
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.initHeader()
        self.startFetchingPhotos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //print("person \(userName) appearing..animated:\(animated) navigation:\(self.navigationController)")
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        if let statusBar = self.tabBarController?.view.viewWithTag(89) {
            statusBar.removeFromSuperview()
        }
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:UIFont.systemFontOfSize(16, weight: 0.3)]
            navigationBar.tintColor = UIColor.whiteColor()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //print("person \(userName) disappearing..animated:\(animated) navigation:\(self.navigationController)")
    }
    
    func initHeader() {
        let url = Five100px.Router.UserProfile(userID!).URLRequest.URL
        let auth = AuthHeaderString().getAuthHeaderString(url, httpMethod: "GET", body: nil)
        //print(url?.absoluteString)
        
        Alamofire.request(.GET, url!, headers: ["Authorization":auth as String]).responseObject({
            (data: Response<User,NSError>) in
            if data.result.error == nil {
                self.user = data.result.value
                self.collectionView?.reloadSections(NSIndexSet(index: 0))
            }
        })
    }
    
    func startFetchingPhotos() {
        let url = Five100px.Router.UserProfilePhotos(self.userID!, self.currentPage, Five100px.ImageSize.Small).URLRequest.URL
        let auth = AuthHeaderString().getAuthHeaderString(url, httpMethod: "GET", body: nil)
        //print(url?.absoluteString)
        
        self.fecthingPhotos = true
        Alamofire.request(.GET, url!, headers: ["Authorization":auth as String]).responseCollection({
            (data: Response<[PhotoInfo],NSError>) in
            if data.result.error == nil {
                let lastItem = self.photos.count
                
                self.photos.appendContentsOf(data.result.value!)
                
                let indexPaths = (lastItem..<self.photos.count).map{
                    NSIndexPath(forRow: $0, inSection: 0)
                }
                
                self.collectionView?.insertItemsAtIndexPaths(indexPaths)
                
                self.fecthingPhotos = false
                self.currentPage += 1
            }
        })
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + 80  && fecthingPhotos == false {
            self.startFetchingPhotos()
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == 0 {
            return self.photos.count ?? 0
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: reusePersonIdentifier, forIndexPath: indexPath)
        } else {
            let footerIndicator = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", forIndexPath: indexPath)
            return footerIndicator
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            if let user = self.user {
                let str = NSString(string: user.about!)
                let size = str.boundingRectWithSize(CGSizeMake(self.view.bounds.width, 1000), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil)
                aboutSize = size.height + 10
            }
            return CGSizeMake(30, kDefaultSize+aboutSize)
        }
        return CGSizeMake(0, 0)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.fecthingPhotos == true {
            return CGSizeMake(44, 44)
        }
        return CGSizeMake(0, 0)
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        if elementKind == UICollectionElementKindSectionHeader {
            if let user = user {
                let header = view as! PersonHeaderReusableView
                header.set(title: NSURL(string: user.userURL!)!, userName: user.fullName!, userIntro: user.about!, backgroundImage: UIImage(named: "background")!, withTextColor: kRMCommonTextColor)
            }
        } else {
            let footerIndicator = view as! IndicatorFooterReusableView
            if self.fecthingPhotos == true {
                footerIndicator.footerStartAnimating()
            } else {
                footerIndicator.footerStopAnimating()
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let photo = self.photos[indexPath.row]
        let postCell = cell as! CollectionViewCell
        postCell.set(imageURL: NSURL(string: photo.url)!)
    }
    
    /*
     override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
     cell.alpha = 1
     UIView.animateWithDuration(0.5, animations: {
     cell.alpha = 0
     })
     }
     
     
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}
