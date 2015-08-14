//
//  ArticleViewController.swift
//  Guess?
//
//  Created by Manoj Singh on 8/14/15.
//  Copyright (c) 2015 Manoj Singh. All rights reserved.
//

/**

/// This viewcontroller contains webview to display the the article story. 

*/

import UIKit

class ArticleViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var urlString: String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        var url = NSURL(string: urlString)
        if let tempURL = url {
            
            activityIndicatorView.startAnimating()
            var urlRequest = NSURLRequest(URL: tempURL)
            webView.loadRequest(urlRequest)
        }
        else {
            
            GuessSingleton.sharedInstance.showAlertWithMessage("Invalid url, failed to load article")
        }
    }

    @IBAction func dismiss(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UIWebViewDelegate Methods
    
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicatorView.startAnimating()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicatorView.stopAnimating()
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        activityIndicatorView.stopAnimating()
        
        var userInfoErrorDict:[NSObject : AnyObject]? = error.userInfo
        var errorMessage = userInfoErrorDict!["NSLocalizedDescription"] as? String
        
        if let errorMsg = errorMessage {
            GuessSingleton.sharedInstance.showAlertWithMessage(errorMessage!)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
