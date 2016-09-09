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
    public func responseCollection<T: ResponseCollectionSerializable>(completionHanlder: (Response<[T],NSError>) -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T],NSError> { request,response,data,error in
            guard error == nil else { return Result.Failure(error!) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: NSJSONReadingOptions.AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request,response,data,error)
            
            if let response = response, let JSON: AnyObject = result.value {
                //print(JSON)
                let validData: [T] = T.collection(response, representation: JSON)
                return Result.Success(validData)
            } else {
                return Result.Failure(result.error!)
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
        
        case popularPhotos(Int)
        case photoInfo(Int, ImageSize)
        case userFriendPhotos(Int, ImageSize)
        case comments(Int, Int)
        case userLists(Int)
        case userProfile(Int)
        case userProfilePhotos(Int,Int,ImageSize)
        
        func getPathParameters() -> (String,[String:AnyObject]){
            switch self {
            case .popularPhotos (let page):
                let params = ["consumer_key": Router.consumerKey, "page": "\(page)", "feature": "popular", "rpp": "50",  "include_store": "store_download", "include_states": "votes"]
                let (path, parameters) = ("/photos", params)
                return (path, parameters)
            case .photoInfo(let photoID, let imageSize):
                let params = ["consumer_key": Router.consumerKey, "image_size": "\(imageSize.rawValue)"]
                let (path, parameters) = ("/photos/\(photoID)", params)
                return (path, parameters)
            case .comments(let photoID, let commentsPage):
                let params = ["page": "\(commentsPage)"]
                let (path, parameters) = ("/photos/\(photoID)/comments", params)
                return (path, parameters)
            case .userLists(let userID):
                let params = ["v": "20131016", "group": "created"]
                let (path, parameters) = ("/users/\(userID)/lists", params)
                return (path, parameters)
            case .userFriendPhotos(let page, let imageSize):
                let params = ["page": "\(page)", "image_size": "\(imageSize.rawValue)","feature":"user_friends","username":"594178994","include_store":"store_download","include_states":"voted"]
                let (path, parameters) = ("/photos",params)
                return (path, parameters)
            case .userProfile(let userID):
                let params = ["id":"\(userID)"]
                let (path, parameters) = ("users/show",params)
                return (path, parameters)
            case .userProfilePhotos(let userID, let page, let imageSize):
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
        case tiny = 1
        case small = 2
        case medium = 3
        case large = 4
        case xLarge = 5
    }
    
    enum Category: Int, CustomStringConvertible {
        case uncategorized = 0, celebrities, film, journalism, nude, blackAndWhite, stillLife, people, landscapes, cityAndArchitecture, abstract, animals, macro, travel, fashion, commercial, concert, sport, nature, performingArts, family, street, underwater, food, fineArt, wedding, transportation, urbanExploration
        
        var description: String {
            get {
                switch self {
                case .uncategorized: return "Uncategorized"
                case .celebrities: return "Celebrities"
                case .film: return "Film"
                case .journalism: return "Journalism"
                case .nude: return "Nude"
                case .blackAndWhite: return "Black_And_White"
                case .stillLife: return "Still_Life"
                case .people: return "People"
                case .landscapes: return "Landscapes"
                case .cityAndArchitecture: return "City_And_Architecture"
                case .abstract: return "Abstract"
                case .animals: return "Animals"
                case .macro: return "Macro"
                case .travel: return "Travel"
                case .fashion: return "Fashion"
                case .commercial: return "Commercial"
                case .concert: return "Concert"
                case .sport: return "Sport"
                case .nature: return "Nature"
                case .performingArts: return "Performing_Arts"
                case .family: return "Family"
                case .street: return "Street"
                case .underwater: return "Underwater"
                case .food: return "Food"
                case .fineArt: return "Fine_Art"
                case .wedding: return "Wedding"
                case .transportation: return "Transportation"
                case .urbanExploration: return "Urban_Exploration"
                }
            }
        }
    }
}
