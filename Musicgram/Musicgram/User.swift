//
//  User.swift
//  Musicgram
//
//  Created by Michealbad on 16/8/4.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Alamofire

class User: ResponseObjectSerializable {
    
    var userName: String?
    var about: String?
    var fullName: String?
    var userURL: String?
    
    @objc required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let dic = representation.valueForKey("user") as! NSDictionary! {
            self.userName = dic.valueForKey( "username") as? String
            self.about = dic.valueForKey("about") as? String
            self.fullName = dic.valueForKey("fullname") as? String
            self.userURL = dic.valueForKey("userpic_url") as? String
        }
    }
    
    class func fetchUser(userID: Int,completion: (User) -> ()) {
        let url = Five100px.Router.userProfile(userID).URLRequest.URL
        let auth = AuthHeaderString().getAuthHeaderString(url, httpMethod: "GET", body: nil)
        
        Alamofire.request(.GET, url!, headers: ["Authorization":auth as String]).responseObject({
            (data: Response<User,NSError>) in
            
            if data.result.error == nil {
                completion(data.result.value!)
            }
            
        })
    }
}
