//
//  FTSQuestionaire.swift
//  NAV
//
//  Created by Alex Chen on 3/21/23.
//

import Foundation

struct FTSQuestionaire{
    
    
    static let Q: [Question] = [
    Question(q: "How cool are you", a: ["slider" as NSString, 13 as NSNumber, 100 as NSNumber]),
    Question(q: "What is benchpress goal?", a: ["slider" as NSString, 30 as NSNumber, 300 as NSNumber]),
    Question(q: "Would you fight a panda?", a: ["polar" as NSString])
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
