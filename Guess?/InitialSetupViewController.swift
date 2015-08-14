//
//  InitialSetupViewController.swift
//  Guess?
//
//  Created by Nissan Infiniti Mac on 13/08/15.
//  Copyright (c) 2015 Manoj Singh. All rights reserved.
//

/**

/// This viewcontroller makes request to fetch the the context objective questions from server and ask the user to wait till recieve response from server. Once data recieved from server it takes into QuestionViewController.

*/

import UIKit

class InitialSetupViewController: UIViewController {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        activityIndicatorView.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            self.fetchContent()
        })
    }
    
    // Fetch the content from server 
    func fetchContent() {
        
        var session = ConnectionManager()
        session.responseType = .JSON
        session.makeRequestWithURL(kContentURL, completionHandler: { (responseData:AnyObject?, error: NSError?) -> Void in
            
            if (error == nil) {
                
                if let tempResponseData: AnyObject = responseData {
                    
                    var questionArray = ModelParser.questionsFromData(data: tempResponseData)
                    GameManager.sharedInstance.allQuestions = questionArray
                    GameManager.sharedInstance.downloadImageForNextQuestionInAdvance()
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.activityIndicatorView.stopAnimating()
                        self.performSegueWithIdentifier("QuestionViewIdentifier", sender: self)
                    })
                }
            }
            else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndicatorView.stopAnimating()
                    var userInfoErrorDict:[NSObject : AnyObject]? = error?.userInfo
                    var errorMessage = userInfoErrorDict!["NSLocalizedDescription"] as? String
                    GuessSingleton.sharedInstance.showAlertWithTitle("Network Error", message: errorMessage!)
                    self.messageLabel.text = errorMessage
                })
            }
        })
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
