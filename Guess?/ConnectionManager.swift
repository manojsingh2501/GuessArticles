//
//  ConnectionManager.swift
//  Guess?
//
//  Created by Nissan Infiniti Mac on 12/08/15.
//  Copyright (c) 2015 Manoj Singh. All rights reserved.
//

/**
    This class is responsible to fetch data from server using NSURLSession. This class uses system base delegate for connection.
    Custom delegate can also be used if authentication, redirection or more controll required.
    But as our requirments is simple so using system base delegate for NSURLSession with limited functionalities 

*/

import UIKit


class ConnectionManager: NSObject, NSURLSessionDelegate {
    
    var urlSession: NSURLSession?
    var responseType: ResponseDataType!
    
    override init() {
        
        super.init()
        
        responseType = .NSData
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSession = NSURLSession(configuration: sessionConfiguration)
    }
    
    func makeRequestWithURL(url: String, completionHandler:((AnyObject?, NSError?) -> Void) ) {
        
        self.makeRequestWithURL(url, httpMethod: "POST", httpHeaderFileds: nil, body: nil, completionHandler: completionHandler)
    }
    
    func makeRequestWithURL(url: String, httpMethod: String, httpHeaderFileds:[String: String]?,  body: NSData?, completionHandler:((AnyObject?,NSError?) -> Void)) {
        
        var urlObj = NSURL(string: url);
        
        if let tempURL = urlObj {
            
            var urlRequest = NSURLRequest(URL: tempURL, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60.0)
            
            self.urlSession?.dataTaskWithRequest(urlRequest, completionHandler: { (data: NSData!, urlResponse:NSURLResponse!, error: NSError!) -> Void in
                
                if error == nil {
                    
                    if let tempData = data {
                        
                        if (self.responseType == ResponseDataType.JSON) {
                            
                            var jsoneError: NSError?
                            
                            var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsoneError)
                            completionHandler(jsonObject, jsoneError)
                        }
                        else {
                            completionHandler(data, error)
                        }
                    }
                    else {
                        completionHandler(data, error)
                    }
                }
                else {
                    completionHandler(data, error)
                }
                
            }).resume()
        }
    }
}
