//
//  ViewController.swift
//  GooglePhotosTransition
//
//  Created by Michealbad on 16/2/26.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton?
    let imageView = UIImageView()
    
    let transitionController = TransitionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn?.backgroundColor = UIColor(red: 65.0/255.0, green: 121.0/255.0, blue: 247.0/255.0, alpha: 1)
        self.imageView.frame = self.view.bounds
        self.imageView.image = UIImage(named: "Image1")
        //self.view.addSubview(self.imageView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toVC = segue.destinationViewController
        toVC.modalPresentationStyle = .Custom
        toVC.transitioningDelegate = self.transitionController
    }
}

