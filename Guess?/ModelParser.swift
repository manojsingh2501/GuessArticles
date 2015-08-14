//
//  ModelParser.swift
//  Guess?
//
//  Created by Nissan Infiniti Mac on 12/08/15.
//  Copyright (c) 2015 Manoj Singh. All rights reserved.
//

import Foundation

// This class is responsible for parsing the given data into requested model. Currenlty it parses data into `ObjectiveQuestion` model.

class ModelParser {
    
    // This is class method convert given dictionary into `ObjectiveQuestion` model
    
    class private func questionModelFromDict(questionDic: [String: AnyObject]) -> ObjectiveQuestion {
        
        var storyURL = questionDic["storyUrl"] as? String
        var section = questionDic["section"] as? String
        var standFirst = questionDic["standFirst"] as? String
        var imageUrl = questionDic["imageUrl"] as? String
        var answerIndex: NSNumber = (questionDic["correctAnswerIndex"] as? NSNumber)!
        var correctAnswerIndex = answerIndex.integerValue
        var headlines = questionDic["headlines"] as? [String]
        
        var question = ObjectiveQuestion()
        question.storyURL = storyURL
        question.section = section
        question.standFirst = standFirst
        question.imageURL = imageUrl
        question.correctAnswerIndex = UInt8(correctAnswerIndex)
        question.possibleAnswers = headlines
        
        return question
    }
    
    
    class func questionsFromData(#data: AnyObject) -> [ObjectiveQuestion]?{
        
        var objectiveQuestions:[ObjectiveQuestion]? = [ObjectiveQuestion]()
        
        var responseDict: [String: AnyObject]? = data as? [String: AnyObject]
        
        if let dataDict = responseDict {
            
            var itemsArray = dataDict["items"] as? [[String: AnyObject]]
            
            if let tempItemsArray = itemsArray {
                
                for item in tempItemsArray {
                    
                    var question = self.questionModelFromDict(item)

                    objectiveQuestions?.append(question)
                }
            }
        }
        
        return objectiveQuestions
    }
}
