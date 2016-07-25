//
//  RMAssetResourceLoader.swift
//  RMPlayer
//
//  Created by Michealbad on 16/4/6.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class RMAssetResourceLoader: NSObject, NSURLConnectionDataDelegate, AVAssetResourceLoaderDelegate {
    
    var connection: NSURLConnection!
    var songData: NSMutableData!
    var request: NSURLRequest!
    var response: NSHTTPURLResponse!
    var pendingRequests = NSMutableArray()
    
    func processPendingRequests() {
        let requestsCompleted = NSMutableArray()
        
        for var loadingRequest in self.pendingRequests {
            self.fillInContentInformation(loadingRequest.contentInformationRequest)
            
            if self.respondWithDataForRequest(loadingRequest.dataRequest) {
                requestsCompleted.addObject(loadingRequest)
                loadingRequest.finishLoading()
            }
        }
        
        self.pendingRequests.removeObjectsInArray(requestsCompleted as [AnyObject])
    }
    
    
    func fillInContentInformation(contentInformationRequest: AVAssetResourceLoadingContentInformationRequest!) {
        
        if contentInformationRequest == nil || self.response == nil {
            return ;
        }
        
        //let mimeType = self.response.MIMEType
        let allHeaderFields = self.response.allHeaderFields
        let contentType = allHeaderFields["allHeaderFields"]
        
        contentInformationRequest.byteRangeAccessSupported = true;
        contentInformationRequest.contentType = contentType as? String;
        contentInformationRequest.contentLength = self.response.expectedContentLength;
    }
    
    func respondWithDataForRequest(dataRequest: AVAssetResourceLoadingDataRequest!) -> Bool {
        let startOffset = dataRequest.currentOffset != 0 ? dataRequest.currentOffset : dataRequest.requestedOffset
        
        if self.songData.length < Int(startOffset) {
            return false
        }
        
        let unreadBytes = self.songData.length - Int(startOffset)
        
        let numberOfBytesToResponse = Int(dataRequest.requestedOffset) < unreadBytes ? Int(dataRequest.requestedOffset) : unreadBytes
        
        dataRequest.respondWithData(self.songData.subdataWithRange(NSMakeRange(Int(startOffset), numberOfBytesToResponse)))
        
        let endOffset = startOffset + dataRequest.requestedLength
        
        return self.songData.length >= Int(endOffset)
    }
    
    //MARK: - AVAssetResourceLoaderDelegate
    func resourceLoader(resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        print("pass shouldWaitForLoadingOfRequestedResource")
        if self.connection == nil {
            let interceptedURL = loadingRequest.request.URL
            let actualURLComponents = NSURLComponents(URL: interceptedURL!, resolvingAgainstBaseURL: false)
            actualURLComponents?.scheme = "http"
            
            self.request = NSURLRequest(URL: (actualURLComponents?.URL)!)
            self.connection = NSURLConnection(request: self.request, delegate: self, startImmediately: false)
            self.connection.setDelegateQueue(NSOperationQueue.mainQueue())
            self.connection.start()
        }
        
        self.pendingRequests.addObject(loadingRequest)
        
        self.processPendingRequests()
        
        return true
    }
    
    
    func resourceLoader(resourceLoader: AVAssetResourceLoader, didCancelLoadingRequest loadingRequest: AVAssetResourceLoadingRequest) {
        print("pass didCancelLoadingRequest")
        self.pendingRequests.removeObject(loadingRequest)
    }
    
    //MARK: - NSURLConnectionDataDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        self.songData = NSMutableData()
        self.response = NSHTTPURLResponse()
        
        self.processPendingRequests()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.songData.appendData(data)
        self.processPendingRequests()
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        /*[self processPendingRequests];
        
        NSString *cachedFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"cached.mp3"];
        
        [self.songData writeToFile:cachedFilePath atomically:YES];*/
        self.processPendingRequests()
        let cacedFilePath = NSTemporaryDirectory().stringByAppendingString("cached.mp3")
        do {
            try self.songData.writeToFile(cacedFilePath, options: .AtomicWrite)
        } catch let e {
            print(e)
        }
    }
    
}


















