//
//  FTSQuestionaire.swift
//  NAV
//
//  Created by Alex Chen on 3/21/23.
//

import Foundation

struct FTSQuestionaire{
    
    
    static let Q: [Question] = [
    Question(q: "How many years have you been training?", a: ["slider" as NSString, 13 as NSNumber, 100 as NSNumber]),
    Question(q: "What is benchpress goal?", a: ["slider" as NSString, 30 as NSNumber, 300 as NSNumber]),
    Question(q: "Have you worked with a coach / personal trainer before?", a: ["polar" as NSString]),
    Question(q: "Which statement best describes your goal?", a: ["multiple" as NSString, "I am looking to increase strength" as NSString, "I am trying to get in shape" as NSString, "I would like to improve my general health" as NSString])
    ]
}

struct Question {
    let text: String
    let answerChoice: [AnyObject]
    
    init(q: String, a: [AnyObject]) {
        text = q
        answerChoice = a
    }
}
