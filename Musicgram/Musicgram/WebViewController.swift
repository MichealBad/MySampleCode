//
//  WebViewController.swift
//  Musicgram
//
//  Created by Michealbad on 16/6/4.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import OAuthSwift

class WebViewController: OAuthWebViewController {
    
    var targetURL : NSURL = NSURL()
    let webView : UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.frame = UIScreen.mainScreen().bounds
        self.webView.scalesPageToFit = true
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        loadAddressURL()
    }
    
    override func handle(url: NSURL) {
        targetURL = url
        super.handle(url)
        
        loadAddressURL()
    }
    
    func loadAddressURL() {
        let req = NSURLRequest(URL: targetURL)
        self.webView.loadRequest(req)
    }
}

// MARK: delegate
extension WebViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.URL?.scheme)
        if let url = request.URL where (url.scheme == "michealbad-musicgram"){
            self.dismissWebViewController()
        }
        return true
    }
}


