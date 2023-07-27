//
//  BuildFunctions.swift
//  NAV
//
//  Created by Alex Chen on 7/8/23.
//

import Foundation

struct BuildFunctions{
    let userInfo: UserInfo?
    
    
    func makeWarmupBlock(_ poolCode: String,_ exercisePool: [EINFOV2], _ numberOfExercises: Int, _ blockID: Int) -> [ExerciseWriteInfo]{
        var builtBlock = [ExerciseWriteInfo]()
        var exercisePool = exercisePool
        switch poolCode{
        case "plyo":
            for count in 0 ... numberOfExercises - 1{
                let chosenExercise = exercisePool.randomElement()!
                builtBlock.append(ExerciseWriteInfo(docID: chosenExercise.docID, order: count, block: blockID))
                exercisePool = exercisePool.filter{ $0 != chosenExercise}
            }
            return builtBlock
        default:
            print("error")
        }
    }
    
    func makeMainBlock(_ poolCode: String,_ exercisePool: [EINFOV2], _ numberOfExercises: Int, _ blockID: Int) -> [ExerciseWriteInfo]{
        var builtBlock = [ExerciseWriteInfo]()
        var exercisePool = exercisePool
        let mainPool = exercisePool.filter {
            $0.priority == 3
        }
        switch poolCode{
        case "upper":
            if numberOfExercises == 3 {
                let mainExercise = getHighestLevel(mainPool)
                builtBlock.append(ExerciseWriteInfo(docID: mainExercise.docID, order: 0, block: blockID))
                exercisePool = exercisePool.filter{ $0 != mainExercise}
                let superSetExercise = fetchExercise("upper", exercisePool, blockID, mainExercise.tags)
                builtBlock.append(ExerciseWriteInfo(docID: superSetExercise.docID, order: 1, block: blockID))
                let coreExercise = fetchExercise("core", coreExercises, blockID, [""])
                builtBlock.append(ExerciseWriteInfo(docID: coreExercise.docID, order: 2, block: blockID))
            }
            if numberOfExercises == 2 {
                let mainExercise = getHighestLevel(mainPool)
                builtBlock.append(ExerciseWriteInfo(docID: mainExercise.docID, order: 0, block: blockID))
                
                let coreExercise = fetchExercise("core", coreExercises, blockID, [""])
                builtBlock.append(ExerciseWriteInfo(docID: coreExercise.docID, order: 2, block: blockID))
                
            }
        default:
            print("error")
        }
        return builtBlock
    }
    
    
    func fetchExercise(_ poolCode: String,_ exercisePool: [EINFOV2], _ blockID: Int, _ filterTag: [String])-> EINFOV2{
        var exercisePool = exercisePool
        
        if filterTag.contains("PUSH"){
            exercisePool = exercisePool.filter {
                $0.tags.contains("PULL")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
            
        }
        return getRecentExercises(poolCode, exercisePool)

    }
    
    func getHighestLevel(_ exercisePool: [EINFOV2]) -> EINFOV2{
        var chosenExercise = exercisePool[0]
        for count in 0 ... exercisePool.count - 1{
            if chosenExercise.level < exercisePool[count].level{
                chosenExercise = exercisePool[count]
            }
        }
        return chosenExercise
    }
    func getRecentExercises(_ poolCode: String, _ exercisePool: [EINFOV2]) -> EINFOV2{
        var exercisePool = exercisePool.filter {
            $0.level <= getCodeLevel(poolCode)
        }
        exercisePool = exercisePool.filter {
            $0.level >= getCodeLevel(poolCode) - 20
        }
        return exercisePool.randomElement() ?? exercisePool[0]
    }
    func getCodeLevel(_ poolCode: String) -> Int{
        var skillTreeLevel = 0
        switch poolCode{
        case "plyo":
            skillTreeLevel = userInfo!.plyoLevel
        case "upper":
            skillTreeLevel = userInfo!.upperLevel
        case "core":
            skillTreeLevel = userInfo!.coreLevel
        case "arms":
            skillTreeLevel = userInfo!.armsLevel
        case "lower":
            skillTreeLevel = userInfo!.lowerLevel
        default:
            print("error")
        }
        return skillTreeLevel
    }
}
