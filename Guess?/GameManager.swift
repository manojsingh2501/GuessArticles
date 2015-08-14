//
//  GameManager.swift
//  Guess?
//
//  Created by Nissan Infiniti Mac on 12/08/15.
//  Copyright (c) 2015 Manoj Singh. All rights reserved.
//

/*

/// GameManager class is responsible for having information about question's datasource, player and currently selected question and download   the article's image for next question in advance.

/// All Game controlling fuctionalities can be added over here. For this demo project added limited functionalities.

*/

import Foundation
import UIKit

class GameManager {
    
    static let sharedInstance = GameManager()
    
    var allQuestions: [ObjectiveQuestion]?
    private var selectedQuestionIndex: Int = -1
    var player: Player?
    let session = ConnectionManager()
    
    private init() {
        
    }
    
    func resetGame() {
        
        selectedQuestionIndex = -1
        allQuestions = nil
    }
    
    func nextQuestion() -> ObjectiveQuestion {
        
        selectedQuestionIndex++
        self.downloadImageForNextQuestionInAdvance()
        let question = allQuestions![selectedQuestionIndex]
        
        return question
    }
    
    func selectedQuestion() -> ObjectiveQuestion {
        
        if (selectedQuestionIndex == -1) {
            selectedQuestionIndex = 0
        }
        
        let question = allQuestions![selectedQuestionIndex]
        return question
    }
    
    func isLastQuestion() -> Bool {
        
        if allQuestions!.count == selectedQuestionIndex+1 {
            return true
        }
        else {
            return false
        }
    }
    
    func downloadImageForNextQuestionInAdvance() {
        
         let question = allQuestions![selectedQuestionIndex + 1]
        self.downloadImageForQuestion(question, completionHandler: nil)
    }
    
    func downloadImageForQuestion(question: ObjectiveQuestion, completionHandler:(()->Void)?) {
        
        var imageURL = question.imageURL
        
        if let tempImageUrl = imageURL {
            
            session.makeRequestWithURL(tempImageUrl, completionHandler: { (data:AnyObject?, error: NSError?) -> Void in
                
                var imageData = data as? NSData
                var imageObj = UIImage(data: imageData!)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    question.image = imageObj
                    
                    if ((completionHandler) != nil) {
                        completionHandler!()
                    }
                })
            })
        }
    }
    
}



