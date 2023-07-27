//
//  test.swift
//  NAV
//
//  Created by Alex Chen on 7/14/23.
//

import Foundation

class ULDayBuilder{
    
    var plyoExercises: [FirestoreExerciseInfo]
    var upperExercises: [FirestoreExerciseInfo]
    var lowerExercises: [FirestoreExerciseInfo]
    var coreExercises: [FirestoreExerciseInfo]
    var armsExercises: [FirestoreExerciseInfo]
    let userInfo: UserInfo
    var blocks: [Int]
    let buildingDay: Int
    
    var builtWorkout = [ChosenExercise]()
    var previousPrograms = [ChosenExercise]()
    var usedMainExercises = [ChosenExercise]()
    
    var duplicatePlyoExercises = [FirestoreExerciseInfo]()
    var duplicateUpperExercises = [FirestoreExerciseInfo]()
    var duplicateLowerExercises = [FirestoreExerciseInfo]()
    var duplicateCoreExercises = [FirestoreExerciseInfo]()
    var duplicateArmsExercises = [FirestoreExerciseInfo]()
    
    init(plyoExercises: [FirestoreExerciseInfo], upperExercises: [FirestoreExerciseInfo], lowerExercises: [FirestoreExerciseInfo], coreExercises: [FirestoreExerciseInfo], armsExercises: [FirestoreExerciseInfo], userInfo: UserInfo, blocks: String, buildingDay: Int) {
        self.plyoExercises = plyoExercises
        self.upperExercises = upperExercises
        self.lowerExercises = lowerExercises
        self.coreExercises = coreExercises
        self.armsExercises = armsExercises
        self.userInfo = userInfo
        self.buildingDay = buildingDay
        
        switch blocks{
        case "SHORT":
            self.blocks = [3,2,2]
        case "MED":
            self.blocks = [3,2,3,2]
        case "LONG":
            self.blocks = [3,2,3,2,2]
        default:
            print("Block Error")
            self.blocks = [3,3,3]
        }
    }
    func removeDuplicate(_ otherDays: [ChosenExercise]){
        for exercise in otherDays{
            
            if exercise.priority == 3{
                usedMainExercises.append(exercise)
            }else{
                plyoExercises = plyoExercises.filter {
                    $0.docPath.contains(exercise.docPath) == false
                }
                upperExercises = upperExercises.filter {
                    $0.docPath.contains(exercise.docPath) == false
                }
                lowerExercises = lowerExercises.filter {
                    $0.docPath.contains(exercise.docPath) == false
                }
                armsExercises = armsExercises.filter {
                    $0.docPath.contains(exercise.docPath) == false
                }
            }
        }
        setPreviousPrograms()
    }
    
    func setPreviousPrograms(){
        print("set")
        previousPrograms = previousPrograms.filter{$0.priority != 3}
        for i in 0 ..< previousPrograms.count{
            for j in 0 ..< plyoExercises.count{
                if plyoExercises[j].docPath == previousPrograms[i].docPath{
                    duplicatePlyoExercises.append(plyoExercises[j])
                }
            }
            for j in 0 ..< upperExercises.count{
                if upperExercises[j].docPath == previousPrograms[i].docPath{
                    duplicateUpperExercises.append(upperExercises[j])
                }
            }
            for j in 0 ..< lowerExercises.count{
                if lowerExercises[j].docPath == previousPrograms[i].docPath{
                    duplicateLowerExercises.append(lowerExercises[j])
                }
            }
            for j in 0 ..< armsExercises.count{
                if armsExercises[j].docPath == previousPrograms[i].docPath{
                    duplicateArmsExercises.append(armsExercises[j])
                }
            }
            for j in 0 ..< coreExercises.count{
                if coreExercises[j].docPath == previousPrograms[i].docPath{
                    duplicateCoreExercises.append(coreExercises[j])
                }
            }
        }
        
    }
    
    
    
    func generateProgram(_ variation: Int) -> [ChosenExercise]{ // Function Called by parent for return program
        makePPLday(variation)
        return builtWorkout
    }
    
    
    
    func makePPLday(_ variation: Int){ //Makes full day based on day variation
        switch variation{
        case 1: // UPPER Focused Day
            let daySplit = "UPPER"
            for blockID in 0 ..< blocks.count{
                if blockID == 0{// WARMUP BLOCK
                    makeWarmupBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 1{// MAIN BLOCK
                    makeMainBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 2{// Second MAIN BLOCK
                    makeAccessoryBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 3{// ACCESSORY BLOCK
                    if blocks.count == 4{
                        makeFinisherBlock(daySplit, blocks[blockID], blockID)
                    }else{
                        makeAccessoryBlock(daySplit, blocks[blockID], blockID)
                    }
                }
                if blockID == 4{// ACCESSORY BLOCK
                    makeFinisherBlock(daySplit, blocks[blockID], blockID)
                }
            }
        case 2: // LOWER Focused Day
            let daySplit = "LOWER"
            for blockID in 0 ..< blocks.count{
                if blockID == 0{// WARMUP BLOCK
                    makeWarmupBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 1{// MAIN BLOCK
                    makeMainBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 2{// Second MAIN BLOCK
                    makeAccessoryBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 3{// ACCESSORY BLOCK
                    if blocks.count == 4{
                        makeFinisherBlock(daySplit, blocks[blockID], blockID)
                    }else{
                        makeAccessoryBlock(daySplit, blocks[blockID], blockID)
                    }
                }
                if blockID == 4{// ACCESSORY BLOCK
                    makeFinisherBlock(daySplit, blocks[blockID], blockID)
                }
            }
        case 3: // UPPER Variation Focused Day
            let daySplit = "UPPER2"
            for blockID in 0 ..< blocks.count{
                if blockID == 0{// WARMUP BLOCK
                    makeWarmupBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 1{// MAIN BLOCK
                    makeMainBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 2{// Second MAIN BLOCK
                    makeAccessoryBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 3{// ACCESSORY BLOCK
                    if blocks.count == 4{
                        makeFinisherBlock(daySplit, blocks[blockID], blockID)
                    }else{
                        makeAccessoryBlock(daySplit, blocks[blockID], blockID)
                    }
                }
                if blockID == 4{// ACCESSORY BLOCK
                    makeFinisherBlock(daySplit, blocks[blockID], blockID)
                }
            }
        case 4: // UPPER Variation Focused Day
            let daySplit = "LOWER2"
            for blockID in 0 ..< blocks.count{
                if blockID == 0{// WARMUP BLOCK
                    makeWarmupBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 1{// MAIN BLOCK
                    makeMainBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 2{// Second MAIN BLOCK
                    makeAccessoryBlock(daySplit, blocks[blockID], blockID)
                }
                if blockID == 3{// ACCESSORY BLOCK
                    if blocks.count == 4{
                        makeFinisherBlock(daySplit, blocks[blockID], blockID)
                    }else{
                        makeAccessoryBlock(daySplit, blocks[blockID], blockID)
                    }
                }
                if blockID == 4{// ACCESSORY BLOCK
                    makeFinisherBlock(daySplit, blocks[blockID], blockID)
                }
            }
        default:
            print("Make Day Error")
        }
    }
    
    
    func makeWarmupBlock(_ daySplit: String, _ numberOfExercises: Int, _ blockID: Int){ // Makes a warmup block based on PLYO
        // Create Local Exercise Pool of Warmup Workouts
        let upperPool = filterWarmups(upperExercises)
        let lowerPool = filterWarmups(lowerExercises)
        
        switch daySplit{
        case "UPPER":
            if numberOfExercises == 3{
                //Upper body Warm Up Exercise
                let firstExercise = fetchExerciseWith(K.s.skillTree.upper, upperPool, blockID, [""]) // Fetch Exercise
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree)) // Append Exercise To Workout
                upperExercises = upperExercises.filter{ $0 != firstExercise} // Filter from Global Exercise Pool
                
                // Plyo Exercise
                let secondExercise = fetchExerciseWith(K.s.skillTree.plyo, plyoExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                plyoExercises = plyoExercises.filter{ $0 != secondExercise}
                
                //Core Exercise
                let thirdExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != thirdExercise}
            }
        case "LOWER":
            if numberOfExercises == 3{
                //Upper body Warm Up Exercise
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerPool, blockID, [""]) // Fetch Exercise
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree)) // Append Exercise To Workout
                upperExercises = upperExercises.filter{ $0 != firstExercise} // Filter from Global Exercise Pool
                
                // Plyo Exercise
                let secondExercise = fetchExerciseWith(K.s.skillTree.plyo, plyoExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                plyoExercises = plyoExercises.filter{ $0 != secondExercise}
                
                //Core Exercise
                let thirdExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != thirdExercise}
            }
        case "UPPER2":
            if numberOfExercises == 3{
                //Upper body Warm Up Exercise
                let firstExercise = fetchExerciseWith(K.s.skillTree.upper, upperPool, blockID, [""]) // Fetch Exercise
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree)) // Append Exercise To Workout
                upperExercises = upperExercises.filter{ $0 != firstExercise} // Filter from Global Exercise Pool
                
                // Plyo Exercise
                let secondExercise = fetchExerciseWith(K.s.skillTree.plyo, plyoExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                plyoExercises = plyoExercises.filter{ $0 != secondExercise}
                
                //Core Exercise
                let thirdExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != thirdExercise}
            }
        case "LOWER2":
            if numberOfExercises == 3{
                //Upper body Warm Up Exercise
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerPool, blockID, [""]) // Fetch Exercise
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree)) // Append Exercise To Workout
                upperExercises = upperExercises.filter{ $0 != firstExercise} // Filter from Global Exercise Pool
                
                // Plyo Exercise
                let secondExercise = fetchExerciseWith(K.s.skillTree.plyo, plyoExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                plyoExercises = plyoExercises.filter{ $0 != secondExercise}
                
                //Core Exercise
                let thirdExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != thirdExercise}
            }
        default:
            print("error")
        }
    }
    
    func makeMainBlock(_ daySplit: String, _ numberOfExercises: Int, _ blockID: Int){// Makes a main block based on send exercisePool
        let lowerMainPool = filterMain(lowerExercises)
        let upperMainPool = filterMain(upperExercises)
        let lowerAccessoryPool = filterAccessory(lowerExercises)
        let upperAccessoryPool = filterAccessory(upperExercises)
        
        
        switch daySplit{
        case "UPPER":
            if numberOfExercises == 3 {
                let mainExercise = fetchMainExerciseWith(upperMainPool, ["PUSH"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != mainExercise}
                
                let secondExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, mainExercise.tags)
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != secondExercise}
                
                let coreExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: coreExercise.docPath, order: 2, block: blockID, priority: coreExercise.priority, skillTree: coreExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != coreExercise}
            }
            if numberOfExercises == 2 {
                let mainExercise = fetchMainExerciseWith(upperMainPool, ["PUSH"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != mainExercise}
                
                let coreExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: coreExercise.docPath, order: 2, block: blockID, priority: coreExercise.priority, skillTree: coreExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != coreExercise}
            }
            if numberOfExercises == 1 {
                let mainExercise = fetchMainExerciseWith(upperMainPool, ["PUSH"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != mainExercise}
            }
        case "LOWER":
            if numberOfExercises == 3 {
                let mainExercise = fetchMainExerciseWith(lowerMainPool, ["SQUAT"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != mainExercise}
                
                let secondExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != secondExercise}
                
                let coreExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: coreExercise.docPath, order: 2, block: blockID, priority: coreExercise.priority, skillTree: coreExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != coreExercise}
            }
            if numberOfExercises == 2 {
                let mainExercise = fetchMainExerciseWith(lowerMainPool, ["SQUAT"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != mainExercise}
                
                let coreExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: coreExercise.docPath, order: 2, block: blockID, priority: coreExercise.priority, skillTree: coreExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != coreExercise}
            }
            if numberOfExercises == 1 {
                let mainExercise = fetchMainExerciseWith(lowerMainPool, ["SQUAT"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != mainExercise}
            }
        case "UPPER2":
            if numberOfExercises == 3 {
                let mainExercise = fetchMainExerciseWith(upperMainPool, ["PUSH"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != mainExercise}
                
                let secondExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, mainExercise.tags)
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != secondExercise}
                
                let coreExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: coreExercise.docPath, order: 2, block: blockID, priority: coreExercise.priority, skillTree: coreExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != coreExercise}
            }
            if numberOfExercises == 2 {
                let mainExercise = fetchMainExerciseWith(upperMainPool, ["PUSH"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != mainExercise}
                
                let coreExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: coreExercise.docPath, order: 2, block: blockID, priority: coreExercise.priority, skillTree: coreExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != coreExercise}
            }
            if numberOfExercises == 1 {
                let mainExercise = fetchMainExerciseWith(upperMainPool, ["PUSH"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != mainExercise}
            }
        case "LOWER2":
            if numberOfExercises == 3 {
                let mainExercise = fetchMainExerciseWith(lowerMainPool, ["HINGE"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != mainExercise}
                
                let secondExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != secondExercise}
                
                let coreExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: coreExercise.docPath, order: 2, block: blockID, priority: coreExercise.priority, skillTree: coreExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != coreExercise}
            }
            if numberOfExercises == 2 {
                let mainExercise = fetchMainExerciseWith(lowerMainPool, ["HINGE"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != mainExercise}
                
                let coreExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: coreExercise.docPath, order: 2, block: blockID, priority: coreExercise.priority, skillTree: coreExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != coreExercise}
            }
            if numberOfExercises == 1 {
                let mainExercise = fetchMainExerciseWith(lowerMainPool, ["HINGE"])
                builtWorkout.append(ChosenExercise(docPath: mainExercise.docPath, order: 0, block: blockID, priority: mainExercise.priority, skillTree: mainExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != mainExercise}
            }
        default:
            print("Day Split Error")
        }
        
    }
    
    func makeAccessoryBlock(_ daySplit: String, _ numberOfExercises: Int, _ blockID: Int){// Makes a main block based on send exercisePool
        var upperAccessoryPool = filterAccessory(upperExercises)
        var lowerAccessoryPool = filterAccessory(lowerExercises)
        let armsAccessoryPool = filterAccessory(armsExercises)
        
        
        switch daySplit{
        case "UPPER":
            if numberOfExercises == 3 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, ["PUSH"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                upperAccessoryPool = upperAccessoryPool.filter{ $0 != firstExercise}
                upperExercises = upperExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWithout(K.s.skillTree.upper, upperAccessoryPool, blockID, firstExercise.tags)
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != secondExercise}
                
                let thirdExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != thirdExercise}
            }
            if numberOfExercises == 2 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, ["PUSH"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWithout(K.s.skillTree.upper, upperAccessoryPool, blockID, firstExercise.tags)
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != secondExercise}
            }
            if numberOfExercises == 1 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, ["PUSH"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != firstExercise}
            }
        case "LOWER":
            if numberOfExercises == 3 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["SQUAT"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerAccessoryPool = lowerAccessoryPool.filter{ $0 != firstExercise}
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != secondExercise}
                
                let thirdExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != thirdExercise}
            }
            if numberOfExercises == 2 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["SQUAT"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 2, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != secondExercise}
                
            }
            if numberOfExercises == 1 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["SQUAT"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
            }
        case "UPPER2":
            if numberOfExercises == 3 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, ["PULL"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                upperAccessoryPool = upperAccessoryPool.filter{ $0 != firstExercise}
                upperExercises = upperExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWithout(K.s.skillTree.upper, upperAccessoryPool, blockID, firstExercise.tags)
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != secondExercise}
                
                let thirdExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != thirdExercise}
            }
            if numberOfExercises == 2 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, ["PULL"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWithout(K.s.skillTree.upper, upperAccessoryPool, blockID, firstExercise.tags)
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != secondExercise}
            }
            if numberOfExercises == 1 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, ["PULL"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                upperExercises = upperExercises.filter{ $0 != firstExercise}
            }
        case "LOWER2":
            if numberOfExercises == 3 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["HINGE"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerAccessoryPool = lowerAccessoryPool.filter{ $0 != firstExercise}
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != secondExercise}
                
                let thirdExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != thirdExercise}
            }
            if numberOfExercises == 2 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["HINGE"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 2, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != secondExercise}
                
            }
            if numberOfExercises == 1 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["HINGE"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
            }
        default:
            print("error Day Split")
        }
    }
    func makeFinisherBlock(_ daySplit: String, _ numberOfExercises: Int, _ blockID: Int){
        var armsAccessoryPool = filterAccessory(armsExercises)
        var upperAccessoryPool = filterAccessory(upperExercises)
        var lowerAccessoryPool = filterAccessory(lowerExercises)
        
        switch daySplit{
        case "UPPER":
            let firstExercise = fetchExerciseWith(K.s.skillTree.arms, armsAccessoryPool, blockID, ["BICEP"])
            builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
            armsAccessoryPool = armsAccessoryPool.filter{ $0 != firstExercise}
            armsExercises = armsExercises.filter{ $0 != firstExercise}
            
            let secondExercise = fetchExerciseWith(K.s.skillTree.arms, armsAccessoryPool, blockID, ["TRICEP"])
            builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            armsExercises = armsExercises.filter{ $0 != secondExercise}
            
            let thirdExercise = fetchExerciseWith(K.s.skillTree.arms, armsAccessoryPool, blockID, ["SHOULDER"])
            builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            armsExercises = armsExercises.filter{ $0 != thirdExercise}
            
            let fourthExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docPath: fourthExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != fourthExercise}
            
            
        case "LOWER":
            if numberOfExercises == 3 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != secondExercise}
                
                let thirdExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != thirdExercise}
                
            }
            if numberOfExercises == 2 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 2, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != secondExercise}
            }
            if numberOfExercises == 1 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
            }
        case "UPPER2": // SAME AS UPPER 7/26/23
            let firstExercise = fetchExerciseWith(K.s.skillTree.arms, armsAccessoryPool, blockID, ["BICEP"])
            builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
            armsAccessoryPool = armsAccessoryPool.filter{ $0 != firstExercise}
            armsExercises = armsExercises.filter{ $0 != firstExercise}
            
            let secondExercise = fetchExerciseWith(K.s.skillTree.arms, armsAccessoryPool, blockID, ["TRICEP"])
            builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            armsExercises = armsExercises.filter{ $0 != secondExercise}
            
            let thirdExercise = fetchExerciseWith(K.s.skillTree.arms, armsAccessoryPool, blockID, ["SHOULDER"])
            builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            armsExercises = armsExercises.filter{ $0 != thirdExercise}
            
            let fourthExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docPath: fourthExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != fourthExercise}
            
            
        case "LOWER2": // SAME AS LOWER 7/26/23
            if numberOfExercises == 3 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != secondExercise}
                
                let thirdExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != thirdExercise}
                
            }
            if numberOfExercises == 2 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
                
                let secondExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
                builtWorkout.append(ChosenExercise(docPath: secondExercise.docPath, order: 2, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
                coreExercises = coreExercises.filter{ $0 != secondExercise}
            }
            if numberOfExercises == 1 {
                let firstExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["OTHER"])
                builtWorkout.append(ChosenExercise(docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
                lowerExercises = lowerExercises.filter{ $0 != firstExercise}
            }
        default:
            print("Day Split Error")
        }
        
    }
    
    
    func getCodeLevel(_ poolCode: String) -> Int{ //Returns skillTreeLevel
        var skillTreeLevel = 0
        switch poolCode{
        case "plyo":
            skillTreeLevel = userInfo.plyoLevel
        case "upper":
            skillTreeLevel = userInfo.upperLevel
        case "core":
            skillTreeLevel = userInfo.coreLevel
        case "arms":
            skillTreeLevel = userInfo.armsLevel
        case "lower":
            skillTreeLevel = userInfo.lowerLevel
        default:
            print("error")
        }
        return skillTreeLevel
    }
    
}


// MARK: Fetch Exercise Functions
extension ULDayBuilder{
    
    func fetchMainExerciseWith(_ exercisePool: [FirestoreExerciseInfo], _ tag: [String]) -> FirestoreExerciseInfo{ // Returns highest level exercise from sent pool
        var chosenExercise = exercisePool[0]
        var filterPool = exercisePool
        for exercise in usedMainExercises{
            filterPool = filterPool.filter{
                $0.docPath.contains(exercise.docPath) == false
            }
        }
        if filterPool.isEmpty == false{
            filterPool = filterPool.filter{$0.tags.contains(tag)}
            for count in 0 ..< filterPool.count{
                if chosenExercise.level < filterPool[count].level{
                    chosenExercise = filterPool[count]
                }
            }
        }else{
            chosenExercise = exercisePool.randomElement()!
        }
        return chosenExercise
    }
    func fetchHighestLevelExercise(_ exercisePool: [FirestoreExerciseInfo]) -> FirestoreExerciseInfo{ // Returns highest level exercise from sent pool
        var chosenExercise = exercisePool[0]
        for count in 0 ... exercisePool.count - 1{
            if chosenExercise.level < exercisePool[count].level{
                chosenExercise = exercisePool[count]
            }
        }
        return chosenExercise
    }
    
    
    func fetchExerciseWithout(_ poolCode: String,_ exercisePool: [FirestoreExerciseInfo], _ blockID: Int, _ filterTag: [String])-> FirestoreExerciseInfo{ // Fetches Exercise Without Sent Tags
        var exercisePool = exercisePool
        
        if filterTag.contains("PUSH"){ // Filters Out Push Exercises
            exercisePool = exercisePool.filter {
                !$0.tags.contains("PUSH")
            }
            exercisePool = exercisePool.filter { // Filters Out Barbell Exercises
                $0.equipment.contains("BB") == false
            }
        }
        if filterTag.contains("PULL"){
            exercisePool = exercisePool.filter {
                !$0.tags.contains("PULL")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
        }
        if filterTag.contains("SQUAT"){
            exercisePool = exercisePool.filter {
                !$0.tags.contains("SQUAT")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
        }
        if filterTag.contains("HINGE"){
            exercisePool = exercisePool.filter {
                !$0.tags.contains("HINGE")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
        }
        if filterTag.contains("OTHER"){
            exercisePool = exercisePool.filter {
                $0.tags.contains("OTHER")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
        }
        
        if exercisePool.isEmpty == true{
            switch poolCode{
            case K.s.skillTree.plyo:
                return duplicatePlyoExercises.randomElement()!
            case K.s.skillTree.upper:
                return duplicateUpperExercises.randomElement()!
            case K.s.skillTree.lower:
                return duplicateLowerExercises.randomElement()!
            case K.s.skillTree.arms:
                return duplicateArmsExercises.randomElement()!
            case K.s.skillTree.core:
                return duplicateCoreExercises.randomElement()!
            default:
                print("Empty Pool Dupilcate Fetch")
            }
        }
        
        
        
        return exercisePool.randomElement()!
    }
    
    func fetchExerciseWith(_ poolCode: String,_ exercisePool: [FirestoreExerciseInfo], _ blockID: Int, _ filterTag: [String])-> FirestoreExerciseInfo{ // Fetches Exercise with Sent Tag
        var exercisePool = exercisePool
        
        if filterTag.contains("PUSH"){ // Filters Out Push Exercises
            exercisePool = exercisePool.filter {
                $0.tags.contains("PUSH")
            }
            exercisePool = exercisePool.filter { // Filters Out Barbell Exercises
                $0.equipment.contains("BB") == false
            }
        }
        if filterTag.contains("PULL"){
            exercisePool = exercisePool.filter {
                $0.tags.contains("PULL")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
        }
        if filterTag.contains("SQUAT"){
            exercisePool = exercisePool.filter {
                $0.tags.contains("SQUAT")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
        }
        if filterTag.contains("HINGE"){
            exercisePool = exercisePool.filter {
                $0.tags.contains("HINGE")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
        }
        if filterTag.contains("OTHER"){
            exercisePool = exercisePool.filter {
                $0.tags.contains("OTHER")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
        }
        if filterTag.contains("SHOULDER"){
            exercisePool = exercisePool.filter {
                $0.tags.contains("SHOULDER")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
        }
        if filterTag.contains("TRICEP"){
            exercisePool = exercisePool.filter {
                $0.tags.contains("TRICEP")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
        }
        if filterTag.contains("BICEP"){
            exercisePool = exercisePool.filter {
                $0.tags.contains("BICEP")
            }
            exercisePool = exercisePool.filter {
                $0.equipment.contains("BB") == false
            }
        }
        if exercisePool.isEmpty == true{
            switch poolCode{
            case K.s.skillTree.plyo:
                return duplicatePlyoExercises.randomElement()!
            case K.s.skillTree.upper:
                return duplicateUpperExercises.randomElement()!
            case K.s.skillTree.lower:
                return duplicateLowerExercises.randomElement()!
            case K.s.skillTree.arms:
                return duplicateArmsExercises.randomElement()!
            case K.s.skillTree.core:
                return duplicateCoreExercises.randomElement()!
            default:
                print("Empty Pool Dupilcate Fetch")
            }
        }
        return exercisePool.randomElement()!
    }
    
}



// MARK: Filter Exercise Pool Funcitons Functions
extension ULDayBuilder{
    func filterWarmups(_ exercisePool: [FirestoreExerciseInfo]) -> [FirestoreExerciseInfo]{
        var newPool = exercisePool
        newPool = newPool.filter{
            $0.priority != 3
        }
        newPool = newPool.filter{
            $0.priority != 2
        }
        newPool = newPool.filter{
            $0.priority != 1
        }
        return newPool
    }
    func filterAccessory(_ exercisePool: [FirestoreExerciseInfo]) -> [FirestoreExerciseInfo]{
        var newPool = exercisePool
        newPool = newPool.filter{
            $0.priority != 3
        }
        newPool = newPool.filter{
            $0.priority != 0
        }
        return newPool
    }
    func filterMain(_ exercisePool: [FirestoreExerciseInfo]) -> [FirestoreExerciseInfo]{
        var newPool = exercisePool
        newPool = newPool.filter{
            $0.priority != 2
        }
        newPool = newPool.filter{
            $0.priority != 1
        }
        newPool = newPool.filter{
            $0.priority != 0
        }
        return newPool
    }
}

