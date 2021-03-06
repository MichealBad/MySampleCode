//
//  TabBarController.swift
//  Musicgram
//
//  Created by Michealbad on 16/5/22.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Alamofire

class TabBarController: UITabBarController {
    
    let kTabBarHeight: CGFloat = 40
    var camerBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = kRMCommonTextColor
        self.tabBar.alpha = 0.93
        
        for item in self.tabBar.items! {
            item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }
        
        addCenterBtn()
        configImagePicker()
        //self.sele
        //OAuthorizationHeader(NSURL(string: "https://api.500px.com/v1/users"), "GET", nil, "LBGxWbqDAxuBhQJfkuTtLJufxSEswGfmxEMeAz0t", "paOFIIErHbo0E7Yj5Vs3nJjCYgxkI1z50jV7k7SJ", "4j7pqL4EaQSFKe5Cj6ugCGNocSHVnHWIhDPqu9vt", "R0rz5aJc4bkcS9i6ii6xHCtZGV1YpLgDh8O4rY47")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //let vc = LoginViewController()
        
        //self.view.addSubview(vc.view)
        
        //self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //print("will layout subviews")
        
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = kTabBarHeight
        tabFrame.origin.y = self.tabBar.frame.origin.y + (self.tabBar.frame.height - tabFrame.height)
        self.tabBar.frame = tabFrame
        self.camerBtn.center = self.tabBar.center
    }
    
    func addCenterBtn() {
        //print("add sbview")
        camerBtn = UIButton(type: .Custom)
        let countOfItems = CGFloat(self.tabBar.items!.count)
        camerBtn.frame = CGRectMake(0, 0, self.tabBar.frame.size.width / countOfItems, kTabBarHeight)
        
        camerBtn.setImage(UIImage(named: "btn_camer"), forState: .Normal)
        camerBtn.addTarget(self, action: #selector(camerStart), forControlEvents: .TouchUpInside)
        self.view.addSubview(camerBtn)
    }
    
    var vc: RMImagePickerController!
    
    func configImagePicker() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0.5
        let size = (self.view.bounds.size.width - 3.0) / 4
        layout.itemSize = CGSizeMake(size, size)
        vc = RMImagePickerController(collectionViewLayout: layout)
    }
    
    func camerStart() {
        self.presentViewController(vc, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
