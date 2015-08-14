//
//  Constants.swift
//  Guess?
//
//  Created by Nissan Infiniti Mac on 12/08/15.
//  Copyright (c) 2015 Manoj Singh. All rights reserved.
//

/*

This is constant file to decalre the constatns that is requried in project.

*/

import Foundation

let kContentURL = "https://dl.dropboxusercontent.com/u/30107414/game.json"
let kPointDetectedOnWrongAnswer = 2


enum ResponseDataType {
    
    case NSData
    case JSON
    case XML
    
    init() {
        
        self = .NSData
    }
}