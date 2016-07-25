//
//  RMURLProtocol.swift
//  RMPlayer
//
//  Created by Michealbad on 16/3/22.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import CoreData

class RMURLProtocol: NSURLProtocol, NSURLConnectionDataDelegate, NSURLConnectionDelegate {
    
    var connection: NSURLConnection!
    
    var mutableData: NSMutableData!
    var response: NSURLResponse!
    
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        
        if NSURLProtocol.propertyForKey("RMPlayerProtocolHandled", inRequest: request) != nil {
            return false
        }
        
        let range = request.valueForHTTPHeaderField("Range")
        //print("request : \(request.URL?.absoluteString) range:\(range)")
        
        return false
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(aRequest: NSURLRequest, toRequest bRequest: NSURLRequest) -> Bool {
        return super.requestIsCacheEquivalent(aRequest, toRequest: bRequest)
    }
    
    override func startLoading() {
        
        let newRequest = self.request.mutableCopy() as! NSMutableURLRequest
        NSURLProtocol.setProperty(true, forKey: "RMPlayerProtocolHandled", inRequest: newRequest)
        
        self.connection = NSURLConnection(request: newRequest, delegate: self)
        
        /*let possibleCachedResponse = self.cachedResponseForCurrentRequest()
        if let cachedResponse = possibleCachedResponse {
            print("serving response from cache")
            
            let data = cachedResponse.valueForKey("data") as! NSData!
            let mimeType = cachedResponse.valueForKey("mimeType") as! String!
            let encoding = cachedResponse.valueForKey("encoding") as! String!
            
            let response = NSURLResponse(URL: self.request.URL!, MIMEType: mimeType, expectedContentLength: data.length, textEncodingName: encoding)
            print(response.expectedContentLength)
            
            self.client!.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
            self.client!.URLProtocol(self, didLoadData: data)
            self.mutableData = data.mutableCopy() as! NSMutableData
            self.client!.URLProtocolDidFinishLoading(self)
        } else {
            let newRequest = self.request.mutableCopy() as! NSMutableURLRequest
            NSURLProtocol.setProperty(true, forKey: "RMPlayerProtocolHandled", inRequest: newRequest)
            
            self.connection = NSURLConnection(request: newRequest, delegate: self)
        }*/
    }
    
    override func stopLoading() {
        if self.connection != nil {
            //print("\(self.connection.currentRequest.URL?.absoluteString): stop loading!")
            self.connection.cancel()
        }
        self.connection = nil
    }
    
    func saveCachedResponse() {
        print("saving the cached response")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let cachedResponse = NSEntityDescription.insertNewObjectForEntityForName("CachedResponse", inManagedObjectContext: context)
        
        cachedResponse.setValue(self.mutableData, forKey: "data")
        cachedResponse.setValue(self.request.URL!.absoluteString, forKey: "url")
        cachedResponse.setValue(NSDate(), forKey: "timestamp")
        cachedResponse.setValue(self.response.MIMEType, forKey: "mimeType")
        cachedResponse.setValue(self.response.textEncodingName, forKey: "encoding")
        cachedResponse.setValue(self.request.valueForHTTPHeaderField("Range"), forKey: "range")
        
        do {
            try context.save()
        } catch let e {
            print("Cannot save the response error code: \(e)")
        }
    }
    
    func cachedResponseForCurrentRequest() -> NSManagedObject? {
        if self.request.URL?.absoluteString == "http://www.baidu190.com/md5/4DC55F321D8AD776B586BC9975DC23DA.mp3" {
            return nil
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("CachedResponse", inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format: "(url == %@)", (self.request.URL?.absoluteString)!,(self.request.URL?.absoluteString)!)
        fetchRequest.predicate = predicate
        
        do {
            let possibleResults = try context.executeFetchRequest(fetchRequest) as! Array<NSManagedObject>
            
            if possibleResults.count != 0 {
                return possibleResults[0]
            }
        } catch let e {
            print(e)
        }
        
        return nil
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        print("content type:\((response as! NSHTTPURLResponse).allHeaderFields["Content-Type"])")
        //print("\(response.expectedContentLength) \(response.suggestedFilename)")
        self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .Allowed)
        
        self.response = response
        self.mutableData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        //print("catching data")
        //self.client?.URLProtocol(self, didLoadData: data)
        
        self.mutableData.appendData(data)
        //print(self.mutableData.length)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        self.client?.URLProtocol(self, didLoadData: self.mutableData)
        self.client?.URLProtocolDidFinishLoading(self)
        
        self.saveCachedResponse()
        print(self.mutableData.length)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.client?.URLProtocol(self, didFailWithError: error)
    }
    
}



















