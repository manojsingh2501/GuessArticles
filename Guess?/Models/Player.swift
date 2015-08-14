//
//  Player.swift
//  Guess?
//
//  Created by Nissan Infiniti Mac on 12/08/15.
//  Copyright (c) 2015 Manoj Singh. All rights reserved.
//

/**

This class is having player information. For this demo, adding very basic information such as name and score.
Other information related to player profile can be added over here.


*/

import UIKit


class Player {
    
    var name: String!
    var score: Int = 0 {
        didSet(newValue) {
            if score < 0 {
                score = 0
            }
        }
    }
    
    init() {
        self.name = "Unknown"
    }
    
    init(name:String) {
        
        self.name = name
    }
}
