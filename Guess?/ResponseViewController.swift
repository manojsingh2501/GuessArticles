//
//  ResponseViewController.swift
//  Guess?
//
//  Created by Manoj Singh on 8/13/15.
//  Copyright (c) 2015 Manoj Singh. All rights reserved.
//

/*
    This viewcontroller displays user's response for question, how much point user got for replying to question.
    what is player's current score and user can click to read story article about question.
    User can click on next question button to attempt next question.

*/

import UIKit

extension UILabel {
    
    func circleWithBorderWidth(borderWidth: CGFloat,borderColor: UIColor) {
        
        let width = self.frame.size.width
        self.layer.cornerRadius = width/2.0
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
        self.clipsToBounds = true
    }
    
    func circleWithBorderWidth(borderWidth: CGFloat) {
        
        self.circleWithBorderWidth(borderWidth, borderColor: UIColor.clearColor())
    }
    
    func circle() {
        
        self.circleWithBorderWidth(0, borderColor: UIColor.clearColor())
    }
    
    func underLineText(text: String!) {
        
        let textRange = NSMakeRange(0, count(text))
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSUnderlineStyleAttributeName , value:NSUnderlineStyle.StyleThick.rawValue, range: textRange)
        self.attributedText = attributedText
    }
}

protocol ResponseViewControllerDelegate {
    
    func chooseNextQuestion()
}

class ResponseViewController: UIViewController {

    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var resultBackgroundLabel: UILabel!
    @IBOutlet weak var leadershipBoardButton: UIButton!
    @IBOutlet weak var readArticleButton: UIButton!
    @IBOutlet weak var standFirstLabel: UILabel!
    @IBOutlet weak var headingImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var responseDelegate: ResponseViewControllerDelegate?
    var currentQuestion: ObjectiveQuestion?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let player = GameManager.sharedInstance.player
        let question = GameManager.sharedInstance.selectedQuestion()
        headingImageView.image = question.image
        standFirstLabel.text = question.standFirst
        backgroundImgView.image = question.image
        player!.score += question.answeredPoint
        let scoreText = "Totoal Score: \(player!.score)"
        scoreLabel.text = scoreText
        
        let width = resultLabel.frame.size.width
        resultLabel.layer.cornerRadius = width/2.0
        resultLabel.layer.borderWidth = 2.0
        resultLabel.layer.borderColor = UIColor.whiteColor().CGColor
        resultLabel.clipsToBounds = true
        
        var pointMessage: String?
        var pointValue: String!
        
        if  question.userDidAttemp == true {
            
            if  question.correctAnswerIndex == question.userAnseredIndex {
                pointValue = "+\(question.answeredPoint)"
                pointMessage = "THAT'S RIGHT!\n\(pointValue) POINTS\n FOR YOU!"
            }
            else {
                pointValue = "\(question.answeredPoint)"
                pointMessage = "THAT'S WRONG!\n\(pointValue) POINTS\n FOR YOU!"
            }
        }
        else {
            
            pointValue = "0"
            
            if question.userGiveup {
                pointMessage = "GIVE UP!\n\(pointValue) POINTS\n FOR YOU!"
            }
            else {
                pointMessage = "TIME ELAPSED!\n\(pointValue) POINTS\n FOR YOU!"
            }
        }
        
        resultLabel.underLineText(pointMessage!)
        
        let textRange = (pointMessage! as NSString).rangeOfString(pointValue)
        
        let attributtedString: NSAttributedString = resultLabel.attributedText
        var mutableAttributedString: NSMutableAttributedString = attributtedString as! NSMutableAttributedString
        let font = UIFont(name: "Arial", size: 28.0)!
        mutableAttributedString.addAttribute(NSFontAttributeName, value: font, range: textRange)
        resultLabel.attributedText = mutableAttributedString
        resultBackgroundLabel.circle()
        
    }
    
    // IBAction funtions

    @IBAction func goToNextQuestion(sender: AnyObject) {
        
        if let delegate = responseDelegate {
            delegate.chooseNextQuestion()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func readArticle(sender: AnyObject) {
        
        self.performSegueWithIdentifier("ArticleViewIdentifier", sender: self)
    }
    @IBAction func showLeaderBoard(sender: AnyObject) {
        
        let player = GameManager.sharedInstance.player
        GuessSingleton.sharedInstance.showAlertWithTitle("Score", message: "Your total score is \(player!.score)")
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        var segueIdentifier = segue.identifier
        
        if (segueIdentifier == "ArticleViewIdentifier") {
            
            let question = GameManager.sharedInstance.selectedQuestion()
            var navigationController = segue.destinationViewController as? UINavigationController
            
            var articleViewController = navigationController?.topViewController as? ArticleViewController
            var storyURL = question.storyURL
            articleViewController?.urlString = storyURL
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
