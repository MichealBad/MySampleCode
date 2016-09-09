//
//  Comment.swift
//  Musicgram
//
//  Created by Michealbad on 16/8/4.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Alamofire

final class Comment: ResponseCollectionSerializable {
    
    static func collection(response: NSHTTPURLResponse, representation: AnyObject) -> [Comment] {
        var comments = [Comment]()
        
        for comment in representation.valueForKeyPath("comments") as! [NSDictionary] {
            comments.append(Comment(JSON: comment))
        }
        
        return comments
    }
    
    let userFullname: String
    let userPictureURL: String
    let commentBody: String
    
    init(JSON: AnyObject) {
        userFullname = JSON.valueForKeyPath("user.fullname") as! String
        userPictureURL = JSON.valueForKeyPath("user.userpic_url") as! String
        commentBody = JSON.valueForKeyPath("body") as! String
        //print("\(userFullname) \(commentBody)")
    }
    
    static var currentPage = 0
    
    class func fetchCommentsAsync(photoID: Int, completion: ([Comment]) -> ()) {
        let url = Five100px.Router.comments(photoID, self.currentPage).URLRequest.URL
        let auth = AuthHeaderString().getAuthHeaderString(url, httpMethod: "GET", body: nil)
        
        Alamofire.request(.GET, url!, headers: ["Authorization":auth as String]).responseCollection() {
            (data: Response<[Comment],NSError>) in
            
            if data.result.error == nil {
                completion(data.result.value!)
            }
            
        }
    }
    
}
