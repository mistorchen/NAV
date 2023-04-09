//
//  SetRepGeneration.swift
//  NAV
//
//  Created by Alex Chen on 3/12/23.
//

import Foundation

struct SetRepGeneration{
    
    static func generateSets() -> Int{
        let sets = Int.random(in: 3 ... 4)
        return sets
    }
    
    static func generateReps() -> Int{
        let reps = Int.random(in: 8 ... 15)
        return reps
    }
    
    
}
