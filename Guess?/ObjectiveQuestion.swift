//
//  ObjectiveQuestion.swift
//  Guess?
//
//  Created by Nissan Infiniti Mac on 12/08/15.
//  Copyright (c) 2015 Manoj Singh. All rights reserved.
//

/**

This is Model class having information about question or we can say article.
// This class is having addition information such as question has been attempted or skipped, how much points user has got for giving the answer to this quesiton.

*/

import UIKit

class ObjectiveQuestion: NSObject {
    
    var question: String?
    var correctAnswerIndex: UInt8?
    var storyURL: String?
    var section: String?
    var standFirst: String?
    var imageURL: String?
    var possibleAnswers: [String]?
    var image: UIImage?
    var answeredPoint: Int = 0
    var userAnseredIndex: UInt8?
    var userDidAttemp: Bool = false
    var userGiveup: Bool = false
    var isDelivered: Bool = false

}
