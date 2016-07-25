//
//  RMAvassetResourceLoader.swift
//  RMPlayer
//
//  Created by Michealbad on 16/3/22.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class RMAvassetResourceLoader: NSObject, NSURLConnectionDataDelegate, AVAssetResourceLoaderDelegate {
    
    // MARK: - AVAssetResourceLoader
    
    var connection: NSURLConnection!
    var songData: NSMutableData!
    var request: NSURLRequest!
    var response: NSHTTPURLResponse!
    var pendingRequests = NSMutableArray()
    var cachedFilePath: NSString!
    var loadFromDisk = false
    
    func processPendingRequests() {
        let requestsCompleted = NSMutableArray()
        
        for index in 0..<self.pendingRequests.count {
            
            let loadingRequest = self.pendingRequests.objectAtIndex(index)
            
            self.fillInContentInformation(loadingRequest.contentInformationRequest)
            
            if self.respondWithDataForRequest(loadingRequest.dataRequest) {
                requestsCompleted.addObject(loadingRequest)
                loadingRequest.finishLoading()
            }
        }
        
        self.pendingRequests.removeObjectsInArray(requestsCompleted as [AnyObject])
    }
    
    func fillInContentInformation(contentInformationRequest: AVAssetResourceLoadingContentInformationRequest!) {
        
        if contentInformationRequest == nil {
            return ;
        }
        
        if self.loadFromDisk == true && self.songData != nil {
            print("loading from disk")
            let contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, self.cachedFilePath.pathExtension, nil)
            
            contentInformationRequest.byteRangeAccessSupported = true
            contentInformationRequest.contentType = contentType?.takeUnretainedValue() as String?
            contentInformationRequest.contentLength = Int64(self.songData.length)
        } else {
            
            if self.response == nil {
                return ;
            }
            
            let mimeType = self.response.MIMEType
            let contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType!, nil)
            
            contentInformationRequest.byteRangeAccessSupported = true;
            contentInformationRequest.contentType = contentType?.takeUnretainedValue() as String?;
            contentInformationRequest.contentLength = self.response.expectedContentLength;
        }
        //print(contentInformationRequest.contentType)
    }
    
    func respondWithDataForRequest(dataRequest: AVAssetResourceLoadingDataRequest!) -> Bool {
        var startOffset = dataRequest.requestedOffset
        if dataRequest.currentOffset != 0 {
            startOffset = dataRequest.currentOffset
        }
        
        if self.songData == nil || self.songData.length < Int(startOffset) {
            return false
        }
        
        let unreadBytes = self.songData.length - Int(startOffset)
        
        let numberOfBytesToResponse = min(dataRequest.requestedLength, unreadBytes)
        
        dataRequest.respondWithData(self.songData.subdataWithRange(NSMakeRange(Int(startOffset), numberOfBytesToResponse)))
        //print("curOS:\(dataRequest.currentOffset) requestOS:\(dataRequest.requestedOffset) startOS:\(startOffset) requestL:\(dataRequest.requestedLength) UNB:\(unreadBytes) NBTR:\(numberOfBytesToResponse) ")
        
        let endOffset = startOffset + dataRequest.requestedLength
        
        return self.songData.length >= Int(endOffset)
    }
    
    //MARK: - AVAssetResourceLoaderDelegate
    func resourceLoader(resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        print("shouldWaitForLoadingOfRequestedResource")
        if self.connection == nil && self.loadFromDisk == false {
            let interceptedURL = loadingRequest.request.URL
            let actualURLComponents = NSURLComponents(URL: interceptedURL!, resolvingAgainstBaseURL: false)
            actualURLComponents?.scheme = "http"
            
            self.request = NSURLRequest(URL: (actualURLComponents?.URL)!)
            self.connection = NSURLConnection(request: self.request, delegate: self, startImmediately: false)
            self.connection.setDelegateQueue(NSOperationQueue.mainQueue())
            self.connection.start()
        }
        
        self.pendingRequests.addObject(loadingRequest)
        if self.loadFromDisk {
            self.processPendingRequests()
        }
        
        return true
    }
    
    
    func resourceLoader(resourceLoader: AVAssetResourceLoader, didCancelLoadingRequest loadingRequest: AVAssetResourceLoadingRequest) {
        print("didCancelLoadingRequest")
        self.pendingRequests.removeObject(loadingRequest)
    }
    
    //MARK: - NSURLConnectionDataDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        print("didReceiveResponse")
        self.songData = NSMutableData()
        self.response = response as! NSHTTPURLResponse
        
        self.processPendingRequests()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.songData.appendData(data)
        //print(songData.length)
        self.processPendingRequests()
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        self.processPendingRequests()
        
        let cacedFilePath = NSTemporaryDirectory().stringByAppendingString("cached.mp3")
        do {
            try self.songData.writeToFile(cacedFilePath, options: .AtomicWrite)
        } catch let e {
            print(e)
        }
    }


}
