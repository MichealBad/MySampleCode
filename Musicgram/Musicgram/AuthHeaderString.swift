//
//  AuthHeaderString.swift
//  Musicgram
//
//  Created by Michealbad on 16/6/6.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Foundation
import OAuthSwift



class AuthHeaderString: NSObject {
    
    let consumerKey: NSString = "LBGxWbqDAxuBhQJfkuTtLJufxSEswGfmxEMeAz0t"
    let consumerSecret: NSString = "paOFIIErHbo0E7Yj5Vs3nJjCYgxkI1z50jV7k7SJ"
    let authKey: NSString = "4j7pqL4EaQSFKe5Cj6ugCGNocSHVnHWIhDPqu9vt"
    let authSecret: NSString = "R0rz5aJc4bkcS9i6ii6xHCtZGV1YpLgDh8O4rY47"
    
    var nonce: String!
    var timestamp: String!
    let signature_method = "HMAC-SHA1"
    let oauth_version = "1.0"
    
    func getAuthHeaderString(url: NSURL!, httpMethod: String!, body: NSData!) -> String {
        
        nonce = "\(Int(arc4random()))"
        timestamp = "\(Int(NSDate().timeIntervalSince1970)))"
        
        let oAuthAuthorizationParameters = NSMutableDictionary()
        oAuthAuthorizationParameters.setObject(nonce, forKey: "oauth_nonce")
        oAuthAuthorizationParameters.setObject(timestamp, forKey: "oauth_timestamp")
        oAuthAuthorizationParameters.setObject(signature_method, forKey: "oauth_signature_method")
        oAuthAuthorizationParameters.setObject(oauth_version, forKey: "oauth_version")
        oAuthAuthorizationParameters.setObject(consumerKey, forKey: "oauth_consumer_key")
        oAuthAuthorizationParameters.setObject(authKey, forKey: "oauth_token")
        
        var additionalQueryParameters: NSDictionary? = nil
        var additionalBodyParameters: NSDictionary? = nil
        if let queryString = url.query {
            additionalQueryParameters = (queryString as NSString).ab_parseURLQueryString()
        }
        
        if let bodyData = body {
            let aStr = NSString(data: bodyData, encoding: NSUTF8StringEncoding)
            if let validStr = aStr {
                additionalBodyParameters = validStr.ab_parseURLQueryString()
            }
        }
        
        let parameters = oAuthAuthorizationParameters.mutableCopy() as! NSMutableDictionary
        if let adQuery = additionalQueryParameters {
            parameters.addEntriesFromDictionary(adQuery as [NSObject : AnyObject])
        }
        if let adBody = additionalBodyParameters {
            parameters.addEntriesFromDictionary(adBody as [NSObject : AnyObject])
        }
        
        let encodedParameterStringArray = NSMutableArray()
        let allKeys = parameters.allKeys
        for key in allKeys {
            let value = parameters.objectForKey(key)
            if value is NSString {
                encodedParameterStringArray.addObject(NSString(format: "%@=%@", key.ab_RFC3986EncodedString(),(value?.ab_RFC3986EncodedString())!))
            } else if value is NSArray {
                for item in value as! NSArray {
                    encodedParameterStringArray.addObject(NSString(format: "%@%%5B%%5D=%@", key.ab_RFC3986EncodedString(),item.ab_RFC3986EncodedString()))
                }
            }
        }
        
        let sortedParameterArray = encodedParameterStringArray.sortedArrayUsingSelector(#selector(NSNumber.compare(_:))) as NSArray
        let normalizedParameterString = sortedParameterArray.componentsJoinedByString("&")
        let normalizedURLString = NSString(format: "%@://%@%@", url.scheme,url.host!,url.path!)
        
        let signatureBaseString = NSString(format: "%@&%@&%@", httpMethod.ab_RFC3986EncodedString(),normalizedURLString.ab_RFC3986EncodedString(),normalizedParameterString.ab_RFC3986EncodedString()) as String
        
        let secret = NSString(format: "%@&%@", NSString(string: consumerSecret).ab_RFC3986EncodedString(), NSString(string: authSecret).ab_RFC3986EncodedString())
        let signatureData = HMAC_SHA1(signatureBaseString, key: secret)
        let base64SinatureString = signatureData.base64EncodedString()
        let authorizationHeaderDictionary = oAuthAuthorizationParameters.mutableCopy() as! NSMutableDictionary
        authorizationHeaderDictionary.setObject(base64SinatureString, forKey: "oauth_signature")
        let authorizationHeaderItems = NSMutableArray()
        let allKeyss = authorizationHeaderDictionary.allKeys
        for key in allKeyss {
            let value = authorizationHeaderDictionary.objectForKey(key)
            authorizationHeaderItems.addObject(NSString(format: "%@=\"%@\"", key.ab_RFC3986EncodedString(),value!.ab_RFC3986EncodedString()))
        }
        
        let authorizationHeaderString = "OAuth \(authorizationHeaderItems.componentsJoinedByString(", "))"
        
        return authorizationHeaderString
    }
    
    func HMAC_SHA1(data: NSString, key: NSString) -> NSData {
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLength)
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), key.UTF8String, key.length, data.UTF8String, data.length, result)
        
        let data = NSData(bytes: result, length: digestLength)
        
        result.dealloc(digestLength)
        
        return data
    }
    
    /*func urlEncode(str: NSString) -> NSString {
     return str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet(charactersInString: ":/?#[]@!$ &'()*+.;=\"<>%{}|\\^~`"))!
     }*/
    
}
