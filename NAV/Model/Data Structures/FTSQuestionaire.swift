//
//  FTSQuestionaire.swift
//  NAV
//
//  Created by Alex Chen on 3/21/23.
//

import Foundation

struct FTSQuestionaire{
    
    
    static let Q: [Question] = [
        Question(q: "Which statement best describes your primary training goal?", a: ["dropdown" as NSString, "I am looking to increase my strength" as NSString, "I would like a more toned body" as NSString, "I would like to lose weight" as NSString, "I would simply like to improve my physical health (no specific goal)" as NSString]),
        Question(q: "Do you have any previous gym training experience?", a: ["polar" as NSString]),
        Question(q: "How many years have you been training?", a: ["stepper" as NSString, 0.5 as NSNumber, 0.5 as NSNumber]),
        Question(q: "Are you comfortable learning a new movement on your own?", a: ["polar" as NSString])
    
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
