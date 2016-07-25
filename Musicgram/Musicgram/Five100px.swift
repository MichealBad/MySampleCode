//
//  Five100px.swift
//  PhotosFall
//
//  Created by Michealbad on 15/11/5.
//  Copyright © 2015年 Michealbad. All rights reserved.
//

import UIKit
import Alamofire

public protocol ResponseCollectionSerializable {
    static func collection(response: NSHTTPURLResponse,representation: AnyObject) -> [Self]
}

extension Alamofire.Request {
    public func responseCollection<T: ResponseCollectionSerializable>(completionHanlder: Response<[T],NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T],NSError> { request,response,data,error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request,response,data,error)
            
            if let response = response, JSON: AnyObject = result.value {
                //print(JSON)
                let validData: [T] = T.collection(response, representation: JSON)
                return .Success(validData)
            } else {
                return .Failure(result.error!)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHanlder)
    }
}

@objc public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Alamofire.Request {
    /* class func objectResponseSerializer<T: ResponseObjectSerializable>() -> ResponseSerializer<T, NSError> {
     return ResponseSerializer { request,response,data,error in
     guard error == nil else { return .Failure(error!) }
     
     let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
     let result = JSONResponseSerializer.serializeResponse(request,response,data,error)
     
     if let response = response, JSON: AnyObject = result.value {
     let validData: T? = T(response: response, representation: JSON)
     return .Success(validData!)
     } else {
     return .Failure(result.error!)
     }
     }
     } */
    
    public func responseObject<T: ResponseObjectSerializable>(completionHandler:Response<T,NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T,NSError>{ request,response,data,error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request,response,data,error)
            
            if let response = response, JSON: AnyObject = result.value {
                //print(JSON)
                let validData: T? = T(response: response, representation: JSON)
                return .Success(validData!)
            } else {
                return .Failure(result.error!)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

extension Alamofire.Request {
    class func imageResponseSerializer() -> ResponseSerializer<UIImage,NSError> {
        return ResponseSerializer {
            _,response,data,error in
            guard error == nil else { return .Failure(error!) }
            
            guard let validData = data where validData.length > 0 else {
                print("data is null~")
                let error = Error.errorWithCode(30, failureReason: "data is null")
                return .Failure(error)
            }
            
            let image = UIImage(data: validData, scale: UIScreen.mainScreen().scale)
            
            return .Success(image!)
        }
    }
    
    func responseImage(completionHandler:Response<UIImage,NSError> -> Void) -> Self {
        return response(responseSerializer: Request.imageResponseSerializer(), completionHandler: completionHandler)
    }
}

struct Five100px {
    enum Router: URLRequestConvertible {
        static let baseURLString = "https://api.500px.com/v1"
        static let consumerKey = "LBGxWbqDAxuBhQJfkuTtLJufxSEswGfmxEMeAz0t"
        
        case PopularPhotos(Int)
        case PhotoInfo(Int, ImageSize)
        case UserFriendPhotos(Int, ImageSize)
        case Comments(Int, Int)
        case UserLists(Int)
        case UserProfile(Int)
        case UserProfilePhotos(Int,Int,ImageSize)
        
        func getPathParameters() -> (String,[String:AnyObject]){
            switch self {
            case .PopularPhotos (let page):
                let params = ["consumer_key": Router.consumerKey, "page": "\(page)", "feature": "popular", "rpp": "50",  "include_store": "store_download", "include_states": "votes"]
                let (path, parameters) = ("/photos", params)
                return (path, parameters)
            case .PhotoInfo(let photoID, let imageSize):
                let params = ["consumer_key": Router.consumerKey, "image_size": "\(imageSize.rawValue)"]
                let (path, parameters) = ("/photos/\(photoID)", params)
                return (path, parameters)
            case .Comments(let photoID, let commentsPage):
                let params = ["page": "\(commentsPage)"]
                let (path, parameters) = ("/photos/\(photoID)/comments", params)
                return (path, parameters)
            case .UserLists(let userID):
                let params = ["v": "20131016", "group": "created"]
                let (path, parameters) = ("/users/\(userID)/lists", params)
                return (path, parameters)
            case .UserFriendPhotos(let page, let imageSize):
                let params = ["page": "\(page)", "image_size": "\(imageSize.rawValue)","feature":"user_friends","username":"594178994","include_store":"store_download","include_states":"voted"]
                let (path, parameters) = ("/photos",params)
                return (path, parameters)
            case .UserProfile(let userID):
                let params = ["id":"\(userID)"]
                let (path, parameters) = ("users/show",params)
                return (path, parameters)
            case .UserProfilePhotos(let userID, let page, let imageSize):
                let params = ["page":"\(page)","image_size": "\(imageSize.rawValue)","user_id": "\(userID)","feature":"user","include_store":"store_download","include_states":"voted"]
                let (path, parameters) = ("/photos",params)
                return (path, parameters)
            }
        }
        
        var URLRequest: NSMutableURLRequest {
            let (path, parameters) = getPathParameters()
            
            let URL = NSURL(string: Router.baseURLString)
            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: parameters).0
        }
        
    }
    
    enum ImageSize: Int {
        case Tiny = 1
        case Small = 2
        case Medium = 3
        case Large = 4
        case XLarge = 5
    }
    
    enum Category: Int, CustomStringConvertible {
        case Uncategorized = 0, Celebrities, Film, Journalism, Nude, BlackAndWhite, StillLife, People, Landscapes, CityAndArchitecture, Abstract, Animals, Macro, Travel, Fashion, Commercial, Concert, Sport, Nature, PerformingArts, Family, Street, Underwater, Food, FineArt, Wedding, Transportation, UrbanExploration
        
        var description: String {
            get {
                switch self {
                case .Uncategorized: return "Uncategorized"
                case .Celebrities: return "Celebrities"
                case .Film: return "Film"
                case .Journalism: return "Journalism"
                case .Nude: return "Nude"
                case .BlackAndWhite: return "Black_And_White"
                case .StillLife: return "Still_Life"
                case .People: return "People"
                case .Landscapes: return "Landscapes"
                case .CityAndArchitecture: return "City_And_Architecture"
                case .Abstract: return "Abstract"
                case .Animals: return "Animals"
                case .Macro: return "Macro"
                case .Travel: return "Travel"
                case .Fashion: return "Fashion"
                case .Commercial: return "Commercial"
                case .Concert: return "Concert"
                case .Sport: return "Sport"
                case .Nature: return "Nature"
                case .PerformingArts: return "Performing_Arts"
                case .Family: return "Family"
                case .Street: return "Street"
                case .Underwater: return "Underwater"
                case .Food: return "Food"
                case .FineArt: return "Fine_Art"
                case .Wedding: return "Wedding"
                case .Transportation: return "Transportation"
                case .UrbanExploration: return "Urban_Exploration"
                }
            }
        }
    }
}

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
        
        self.width = representation.valueForKey("width") as! Double
        self.height = representation.valueForKey("height") as! Double
        
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
        self.userID = representation.valueForKey("user_id") as? Int
        self.userPictureURL = representation.valueForKeyPath("user.userpic_url") as? String
    }
    
    static func collection(response: NSHTTPURLResponse, representation: AnyObject) -> [PhotoInfo] {
        var photos = [PhotoInfo]()
        
        for info in representation.valueForKey("photos") as! [NSDictionary] {
            photos.append(PhotoInfo(response: response, representation: info))
        }
        
        return photos
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! PhotoInfo).id == self.id
    }
    
    override var hash: Int {
        return (self as PhotoInfo).id
    }
}

class User: ResponseObjectSerializable {
    
    var userName: String?
    var about: String?
    var fullName: String?
    var userURL: String?
    
    @objc required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let dic = representation.valueForKey("user") as! NSDictionary! {
            self.userName = dic.valueForKey("username") as? String
            self.about = dic.valueForKey("about") as? String
            self.fullName = dic.valueForKey("fullname") as? String
            self.userURL = dic.valueForKey("userpic_url") as? String
        }
    }
}

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
}
