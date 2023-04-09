//
//  FTSQuestionaire.swift
//  NAV
//
//  Created by Alex Chen on 3/21/23.
//

import Foundation

struct FTSQuestionaire{
    
    
    static let Q: [Question] = [
    Question(q: "How old are you", a: ["slider" as NSString, 13 as NSNumber, 100 as NSNumber]),
    Question(q: "How much do you weigh?", a: ["slider" as NSString, 30 as NSNumber, 300 as NSNumber]),
    Question(q: "Have you ever been formally trained by a coach?", a: ["polar" as NSString])
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
