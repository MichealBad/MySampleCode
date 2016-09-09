//
//  PhotoInfo.swift
//  Musicgram
//
//  Created by Michealbad on 16/8/4.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Alamofire

final class PhotoInfo: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    let id: Int
    let url: String
    
    var name: String?
    
    var favoritesCount: Int?
    var votesCount: Int?
    var commentsCount: Int?
    
    var width: Double = 0.0
    var height: Double = 0.0
    
    var highest: Float?
    var pulse: Float?
    var views: Int?
    var camera: String?
    var focalLength: String?
    var shutterSpeed: String?
    var aperture: String?
    var iso: String?
    var category: Five100px.Category?
    var taken: String?
    var uploaded: String?
    var desc: String?
    
    var username: String?
    var fullname: String?
    var userID: Int?
    var userPictureURL: String?
    
    init(id: Int, url: String) {
        self.id = id
        self.url = url
    }
    
    
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.id = representation.valueForKeyPath("id") as! Int
        self.url = representation.valueForKeyPath("image_url") as! String
        
        self.width = representation.valueForKeyPath("width") as! Double
        self.height = representation.valueForKeyPath("height") as! Double
        
        self.favoritesCount = representation.valueForKeyPath("favorites_count") as? Int
        self.votesCount = representation.valueForKeyPath("votes_count") as? Int
        self.commentsCount = representation.valueForKeyPath("comments_count") as? Int
        self.highest = representation.valueForKeyPath("highest_rating") as? Float
        self.pulse = representation.valueForKeyPath("rating") as? Float
        self.views = representation.valueForKeyPath("times_viewed") as? Int
        self.camera = representation.valueForKeyPath("camera") as? String
        self.focalLength = representation.valueForKeyPath("focal_length") as? String
        self.shutterSpeed = representation.valueForKeyPath("shutter_speed") as? String
        self.aperture = representation.valueForKeyPath("aperture") as? String
        self.iso = representation.valueForKeyPath("iso") as? String
        self.category = Five100px.Category(rawValue: representation.valueForKey("category") as! Int)
        self.taken = representation.valueForKeyPath("taken_at") as? String
        self.uploaded = representation.valueForKeyPath("created_at") as? String
        self.desc = representation.valueForKeyPath("description") as? String
        self.name = representation.valueForKeyPath("name") as? String
        
        self.username = representation.valueForKeyPath("user.username") as? String
        self.fullname = representation.valueForKeyPath("user.fullname") as? String
        self.userID = representation.valueForKeyPath("user_id") as? Int
        self.userPictureURL = representation.valueForKeyPath("user.userpic_url") as? String
    }
    
    static func collection(response: NSHTTPURLResponse, representation: AnyObject) -> [PhotoInfo] {
        var photos = [PhotoInfo]()
        
        for info in representation.valueForKey("photos") as! [NSDictionary] {
            photos.append(PhotoInfo(response: response, representation: info))
        }
        
        return photos
    }
    
    func isEqual(object: Any!) -> Bool {
        return (object as! PhotoInfo).id == self.id
    }
    
    override var hash: Int {
        return (self as PhotoInfo).id
    }
    
    class func fetchPhotosAsync(url: NSURL, completion: ([PhotoInfo])->()) {
        let auth = AuthHeaderString().getAuthHeaderString(url, httpMethod: "GET", body: nil)
        
        Alamofire.request(.GET, url, headers: ["Authorization":auth]).responseCollection({
            (data: Response<[PhotoInfo],NSError>) in
            if data.result.error == nil {
                completion(data.result.value!)
            }
        })
    }
    
    
    
}
