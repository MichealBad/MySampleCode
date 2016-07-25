//
//  LrcViewDelegate.swift
//  RMPlayer
//
//  Created by Michealbad on 16/3/25.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

class LrcViewDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var LRC: [(String,String)] = []

    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LRC.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let LrcCell = tableView.dequeueReusableCellWithIdentifier("LrcCell")
        LrcCell?.selectionStyle = .None
        LrcCell?.textLabel?.numberOfLines = 0
        LrcCell?.textLabel?.text = LRC[indexPath.row].1
        
        return LrcCell!
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 32
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.textLabel?.font = UIFont.systemFontOfSize(13)
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.textColor = UIColor.whiteColor()
    }
    
}
