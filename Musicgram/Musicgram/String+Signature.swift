//
//  String+Signature.swift
//  Musicgram
//
//  Created by Michealbad on 16/6/6.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

extension String {
    
    func urlencode() -> String {
        let urlEncoded = self.stringByReplacingOccurrencesOfString(" ", withString: "+")
        return urlEncoded.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    func hmacsha1(key: String) -> NSData {
        
        let dataToDigest = self.dataUsingEncoding(NSUTF8StringEncoding)
        let secretKey = key.dataUsingEncoding(NSUTF8StringEncoding)
        
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLength)
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), secretKey!.bytes, secretKey!.length, dataToDigest!.bytes, dataToDigest!.length, result)
        
        return NSData(bytes: result, length: digestLength)
        
    }
    
}
