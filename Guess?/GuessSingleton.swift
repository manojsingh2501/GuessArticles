//
//  GuessSingleton.swift
//  Guess?
//
//  Created by Manoj Singh on 8/14/15.
//  Copyright (c) 2015 Manoj Singh. All rights reserved.
//

import UIKit

/**
 /// Description

This is Singleton class having utilities methods and or single copy resoureces that are required frequently in application.  

*/

class GuessSingleton {
   
    static let sharedInstance = GuessSingleton()
    
    private init() {
        
    }
    /**
    
    Description: Convinience method to display the alert box with given message.
    
    :param: message To be displayed in alert view
    */
    func showAlertWithMessage(message: String) {
        
        self.showAlertWithTitle(nil, message: message)
    }
    /**
    Description
    This method display alertbox with single button "Ok"
    
    :param: title   To display  alert view title.
    :param:  message To be displayed in alert view
    */
    func showAlertWithTitle(title: String?, message: String) {
        
        var alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    /**
        This method checkes whether network connection is available or not.
        :return: Return boolean variable `true` if netowrk reachable otherwise returns `false`
    */
    func isNetworkReachable() -> Bool {
        
        let internetReachability: Reachability = Reachability.reachabilityForInternetConnection()
        var networkStatus: NetworkStatus = internetReachability.currentReachabilityStatus()
        
        if networkStatus.value == 0 {
            
            return false
        }
        
        return true
    }
}
