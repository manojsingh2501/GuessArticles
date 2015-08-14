//
//  ViewController.swift
//  Guess?
//
//  Created by Nissan Infiniti Mac on 12/08/15.
//  Copyright (c) 2015 Manoj Singh. All rights reserved.
//

/**

/// This viewcontroller displays the article image and 3 possible headlines in which the player is provided 10 seconds to make a correct guess.
/// Once user chooses the answer or time expired, a ResponseView screen is displayed.
// If Article's image is availabel, Point timer start immediately. If article's image is not available it makes call to downlaod image and as soon as image is downlaoded, Point timer starts.

*/

import UIKit

let firstButtonIndex = 100
let secondButtonIndex = 101
let thirdButtonIndex = 102

let startGameButtonTag = 200
let stopGameButtonTag = 300

let baseTag = 100


let QuestionMaxPoint = 10

class QuestionViewController: UIViewController, ResponseViewControllerDelegate {

    @IBOutlet weak var guessImageView: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var firstOptionButton: UIButton!
    @IBOutlet weak var secondOptionButton: UIButton!
    @IBOutlet weak var thirdOptionButton: UIButton!
    @IBOutlet weak var giveUpButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var firstOptionLabel: UILabel!
    @IBOutlet weak var secondOptionLabel: UILabel!
    @IBOutlet weak var thirdOptionLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var categoryButton: UIButton!
    
    var isTimerRunning = false
    var pointTimer: NSTimer?
    var currentQuesitonPoint: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guessImageView.layer.borderColor = UIColor.whiteColor().CGColor
        guessImageView.layer.borderWidth  = 1
        progressView.hidden = true
        startGame()
        
    }
    
    // IBAction functions
    
    @IBAction func chooseAnswer(sender: AnyObject) {
        
        if isTimerRunning == false {
            return
        }
        self.stopPointTimer()
        var optionButton: UIButton = (sender as? UIButton)!
        let selQuestion = GameManager.sharedInstance.selectedQuestion()
        var choosedIndex = UInt8(optionButton.tag - baseTag)
        selQuestion.userAnseredIndex = choosedIndex
        selQuestion.userDidAttemp = true
        selQuestion.answeredPoint = selQuestion.correctAnswerIndex == choosedIndex ? currentQuesitonPoint : -kPointDetectedOnWrongAnswer
        self.performSegueWithIdentifier("ResponseViewIdentifier", sender: self)
    }
    
    @IBAction func skipTheQuestion(sender: AnyObject) {
        
        if isTimerRunning == false {
            return
        }
        
        self.stopPointTimer()
        var question = GameManager.sharedInstance.selectedQuestion()
        question.userGiveup = true
        question.answeredPoint = 0
        self.performSegueWithIdentifier("ResponseViewIdentifier", sender: self)
    }
    
    // Methods to start and stop the game
    func startGame() {
        
        GameManager.sharedInstance.player = Player(name: "PlayerOne")
        self.showNextQuestion()
    }
    
    func stopGame() {
        GameManager.sharedInstance.resetGame()
    }
    
    // Private functions
    private func showNextQuestion() {
        
        let question = GameManager.sharedInstance.nextQuestion()
        
        pointLabel.text = ""
        self.stopPointTimer()
                
        if question.image != nil {
        
            self.showOptionsForQuestion()
        }
        else {
            
            if GuessSingleton.sharedInstance.isNetworkReachable() {
                
                guessImageView.image = nil
                activityIndicatorView.startAnimating()
                GameManager.sharedInstance.downloadImageForQuestion(question, completionHandler: { () -> Void in
                    
                    self.activityIndicatorView.stopAnimating()
                    self.showOptionsForQuestion()
                })
            }
            else {
                GuessSingleton.sharedInstance.showAlertWithTitle("Network Error", message: "Internet connection appeared to be offline.")
            }
        }
    }
    
    private func showOptionsForQuestion() {
        
        let question = GameManager.sharedInstance.selectedQuestion()
        var possibleAnswers: [String]? = question.possibleAnswers
        
        question.isDelivered = true
        currentQuesitonPoint = 10
        backgroundImageView.image = question.image
        guessImageView.image = question.image
        categoryButton.setTitle(question.section, forState: UIControlState.Normal)
        
        self.pointLabel.text = "+\(self.currentQuesitonPoint) Points coming your ways"
        
        if let tempPossibleAnswers = possibleAnswers {
            
            if tempPossibleAnswers.count == 3 {
                
                var firstOption = tempPossibleAnswers[0]
                var secondOption = tempPossibleAnswers[1]
                var thirdOption = tempPossibleAnswers[2]
                
                firstOptionLabel.text = firstOption
                secondOptionLabel.text = secondOption
                thirdOptionLabel.text = thirdOption
                
                self.progressView.progress = 0.0
                pointLabel.text = "+\(currentQuesitonPoint) Points coming your ways"
            }
        }
        
        self.startPointTimer()
    }
    
     func updateProgressView() {
        
        var progress = progressView.progress
        
        if(progress == 1.0) {
            
            self.stopPointTimer()
            self.performSegueWithIdentifier("ResponseViewIdentifier", sender: self)
        }
        else {
            currentQuesitonPoint--
            progressView.progress = progressView.progress + 0.1
            pointLabel.text = "+\(currentQuesitonPoint) Points coming your ways"
        }
    }
    
    private func startPointTimer() {
        
        if let timer = self.pointTimer {
            timer.invalidate()
            self.pointTimer = nil
        }
        isTimerRunning = true
        self.pointTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgressView", userInfo: nil, repeats: true)
        progressView.hidden = false
    }
    
    private func stopPointTimer() {
        
        isTimerRunning = false
        if let timer = self.pointTimer {
            
            timer.invalidate()
            self.pointTimer = nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var segueIdentifier = segue.identifier
        
        if (segueIdentifier == "ResponseViewIdentifier") {
            
            var responseViewController = segue.destinationViewController as? ResponseViewController
            responseViewController?.responseDelegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ResponseViewControllerDelegate method
    
    func chooseNextQuestion() {
        
        self.showNextQuestion()
    }
}



