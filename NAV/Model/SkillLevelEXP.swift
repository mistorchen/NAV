//
//  SkillLevelEXP.swift
//  NAV
//
//  Created by Alex Chen on 6/23/23.
//

import Foundation

struct SkillLevelEXP{
    
    
    
    
    static func levelUp(_ currentLevel: Int, _ exp: Int) -> [Int]{
        let newExp = exp + 50

        if currentLevel <= 20{
            if newExp >= 100{
                return [currentLevel + 1, newExp - 100]
            }else{
                return [currentLevel, newExp]
            }
        }else if currentLevel > 20 && currentLevel <= 50{
            if newExp >= 150{
                return [currentLevel + 1, newExp - 150]
            }else{
                return [currentLevel, newExp]
            }
        }else if currentLevel > 50{
            if newExp >= 200{
                return [currentLevel + 1, newExp - 200]
            }else{
                return [currentLevel, newExp]
            }
        }
        return [0,0]
    }
    
    
}
