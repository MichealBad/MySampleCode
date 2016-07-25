//
//  LoginViewController.swift
//  Musicgram
//
//  Created by Michealbad on 16/6/5.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: UIViewController {
    
    var services = Services()
    var DocumentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    var FileManager = NSFileManager.defaultManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.grayColor()
        
        self.initConf()
        print(services["500px"])
        
        //self.get_url_handler()
        self.doAuthService("500px")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var confPath: String {
        let appPath = "\(DocumentDirectory)/.oauth/"
        if !FileManager.fileExistsAtPath(appPath) {
            do {
                try FileManager.createDirectoryAtPath(appPath, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("failed create directory at \(appPath)")
            }
        }
        return "\(appPath)Services.plist"
    }
    
    func initConf() {
        print("load config from \(confPath)")
        
        if let path = NSBundle.mainBundle().pathForResource("Services", ofType: "plist") {
            if !FileManager.fileExistsAtPath(confPath) {
                do {
                    try FileManager.copyItemAtPath(path, toPath: confPath)
                    //print("copy \(path) to \(confPath)")
                }catch {
                    print("fail copy \(path) to \(confPath)")
                }
            }
        }
        services.loadFromFile(confPath)
    }
    
    func get_url_handler() -> OAuthSwiftURLHandlerType {
        return WebViewController()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LoginViewController {
    
    func doAuthService(service: String) {
        guard let parameters = services[service] else {
            showAlertView("Miss configuration", message: "\(service) not configured")
            return
        }
        
        if Services.parametersEmpty(parameters) { // no value to set
            let message = "\(service) seems to have not weel configured. \nPlease fill consumer key and secret into configuration file \(self.confPath)"
            print(message)
            showAlertView("Miss configuration", message: message)
            // TODO here ask for parameters instead
        }
        
        doOAuth500px(parameters)
    }
    
    func doOAuth500px(serviceParameters: [String:String]){
        let oauthswift = OAuth1Swift(
            consumerKey:    serviceParameters["consumerKey"]!,
            consumerSecret: serviceParameters["consumerSecret"]!,
            requestTokenUrl: "https://api.500px.com/v1/oauth/request_token",
            authorizeUrl:"https://api.500px.com/v1/oauth/authorize",
            accessTokenUrl:"https://api.500px.com/v1/oauth/access_token"
        )
        
        oauthswift.authorize_url_handler = self.get_url_handler()
        
        oauthswift.authorizeWithCallbackURL( NSURL(string: "michealbad-musicgram://oauth-callback/500px")!,success: {credential, response, parameters in
                self.showTokenAlert(serviceParameters["name"], credential: credential)
            }, failure: { error in
                print(error.localizedDescription)
        })
    }
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauth_token)"
        if !credential.oauth_token_secret.isEmpty {
            message += "\n\noauth_toke_secret:\(credential.oauth_token_secret)"
        }
        print(message)
        self.showAlertView(name ?? "Service", message: message)
        
        if let service = name {
            services.updateService(service, dico: ["authentified":"1"])
            // TODO refresh graphic
        }
    }
}
