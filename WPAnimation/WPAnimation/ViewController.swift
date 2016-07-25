//
//  ViewController.swift
//  WPAnimation
//
//  Created by Michealbad on 16/6/23.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let wp = WPActivityIndicator(frame: CGRectMake(60, 100, 200, 200))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(wp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func play(sender: AnyObject) {
        
        wp.isAnimating ? wp.stopAnimating() : wp.startAnimating()
        
    }

}

