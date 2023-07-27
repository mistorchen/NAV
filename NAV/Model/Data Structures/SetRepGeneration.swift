//
//  SetRepGeneration.swift
//  NAV
//
//  Created by Alex Chen on 7/27/23.
//

import Foundation

struct SetRepGeneration{
    func generateSetsReps(_ builtWorkout: [ChosenExercise]) -> [CompleteExerciseInfo]{
        var completeWorkout = [CompleteExerciseInfo]()
        for exercise in builtWorkout{
            completeWorkout.append(CompleteExerciseInfo(docPath: exercise.docPath, order: exercise.order, block: exercise.block, priority: exercise.priority, skillTree: exercise.skillTree, sets: determineSets(), reps: determineReps()))
        }
        
        return completeWorkout
    }
    
    func determineSets() -> Int{
        return 3
    }
    func determineReps() -> Int{
        return 8
    }
}
