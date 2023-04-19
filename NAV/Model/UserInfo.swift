//
//  UserInfo.swift
//  NAV
//
//  Created by Alex Chen on 4/14/23.
//

import Foundation

struct UserInfo {
    var playerLevel: Int
    var trainingType: Int // 0 = Str, 1 = Hyp , 2 = End
    var upperLevel: Int
    var lowerLevel: Int
    var plyoLevel: Int
    var coreLevel: Int
    var armsLevel: Int
    
    init(playerLevel: Int, trainingType: Int, upperLevel: Int, lowerLevel: Int, plyoLevel: Int, coreLevel: Int, armsLevel: Int) {
        self.playerLevel = playerLevel
        self.trainingType = trainingType
        self.upperLevel = upperLevel
        self.lowerLevel = lowerLevel
        self.plyoLevel = plyoLevel
        self.coreLevel = coreLevel
        self.armsLevel = armsLevel
    }
    
}
