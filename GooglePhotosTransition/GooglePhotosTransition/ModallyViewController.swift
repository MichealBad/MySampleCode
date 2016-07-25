//
//  ModallyViewController.swift
//  GooglePhotosTransition
//
//  Created by Michealbad on 16/2/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class ModallyViewController: UIViewController {
    
    let closeBtn: UIButton = UIButton()
    
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.frame = self.view.bounds
        self.imageView.image = UIImage(named: "Image")
        self.view.addSubview(self.imageView)
        
        self.closeBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)-80.0, CGRectGetHeight(self.view.frame)-80.0, 60, 60)
        self.closeBtn.layer.cornerRadius = 30.0
        self.closeBtn.layer.shadowOffset = CGSizeMake(1, 1)
        self.closeBtn.layer.shadowColor = UIColor.blackColor().CGColor
        self.closeBtn.layer.shadowOpacity = 0.6
        self.closeBtn.backgroundColor = UIColor(red: 186.0/255.0, green: 39.0/255.0, blue: 53.0/255.0, alpha: 1)
        self.closeBtn.titleLabel?.font = UIFont.systemFontOfSize(30.0)
        self.closeBtn.setTitle("+", forState: .Normal)
        self.closeBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.closeBtn.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        self.closeBtn.addTarget(self, action: Selector("closeAction:"), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.closeBtn)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("panned:"))
        self.view.addGestureRecognizer(panGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeAction(sender: AnyObject) {
        if let transitionDelegate = self.transitioningDelegate as? TransitionController {
            if sender is UIPanGestureRecognizer {
                transitionDelegate.gestureRecognizer = sender as? UIPanGestureRecognizer
            } else {
                transitionDelegate.gestureRecognizer = nil
            }
        }
        //print("123")
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func panned(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .Began && gestureRecognizer.velocityInView(self.view).y > 0{
            self.closeAction(gestureRecognizer)
        }
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
