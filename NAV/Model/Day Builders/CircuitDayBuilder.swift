//
//  CircuitDayBuilder.swift
//  NAV
//
//  Created by Alex Chen on 7/26/23.
//

import Foundation

class CircuitDayBuilder{
    
    var plyoExercises: [FirestoreExerciseInfo]
    var upperExercises: [FirestoreExerciseInfo]
    var lowerExercises: [FirestoreExerciseInfo]
    var coreExercises: [FirestoreExerciseInfo]
    var armsExercises: [FirestoreExerciseInfo]
    let userInfo: UserInfo
    var blocks: [Int]
    let buildingDay: Int
//    let equipmentList: [String]
    
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
            self.blocks = [5,5]
        case "MED":
            self.blocks = [6,6]
        case "LONG":
            self.blocks = [5,5,6]
        default:
            self.blocks = [5,5]
        }
    }
    
    
    func removeDuplicate(_ otherDays: [ChosenExercise]){
        previousPrograms = otherDays
        for exercise in otherDays{
            if exercise.priority == 3{
                usedMainExercises.append(exercise)
            }else{
                plyoExercises = plyoExercises.filter {
                    !$0.docPath.contains(exercise.docPath)
                }
                upperExercises = upperExercises.filter {
                    !$0.docPath.contains(exercise.docPath)
                }
                lowerExercises = lowerExercises.filter {
                    !$0.docPath.contains(exercise.docPath)
                }
                armsExercises = armsExercises.filter {
                    !$0.docPath.contains(exercise.docPath)
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
    
    
    func generateProgram() -> [ChosenExercise]{ // Function Called by parent for return program
        makeCircuitDay()
        return builtWorkout
    }
    
    
    
    func makeCircuitDay(){ //Makes full day based on day variation
        for blockID in 0 ... blocks.count - 1{
            if blockID == 0{// WARMUP BLOCK
                makeStrengthCircuit(blocks[blockID], blockID)
            }
            if blockID == 1{// MAIN BLOCK
                if blocks.count == 2{
                    makeCoreCircuit(blocks[blockID], blockID)
                }else{
                    makeStrengthCircuit(blocks[blockID], blockID)
                }
            }
            if blockID == 2{// Second MAIN BLOCK
                makeCoreCircuit(blocks[blockID], blockID)
            }
        }
    }
    func makeStrengthCircuit(_ numberOfExercises: Int, _ blockID: Int){ // Makes a warmup block based on PLYO
        let upperAccessoryPool = filterAccessory(upperExercises)
        let lowerAccessoryPool = filterAccessory(lowerExercises)
        
        if numberOfExercises == 6 {
            let firstExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, ["PUSH"])
            builtWorkout.append(ChosenExercise(docID: firstExercise.docID, docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
            upperExercises = upperExercises.filter{ $0 != firstExercise}
            
            let secondExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["SQUAT"])
            builtWorkout.append(ChosenExercise(docID: secondExercise.docID, docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            lowerExercises = lowerExercises.filter{ $0 != secondExercise}
            
            let thirdExercise = fetchExerciseWithout(K.s.skillTree.plyo, plyoExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: thirdExercise.docID, docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
            plyoExercises = plyoExercises.filter{ $0 != thirdExercise}
            
            let fourthExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, ["PULL"])
            builtWorkout.append(ChosenExercise(docID: fourthExercise.docID, docPath: fourthExercise.docPath, order: 3, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
            upperExercises = upperExercises.filter{ $0 != fourthExercise}
            
            let fifthExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["HINGE"])
            builtWorkout.append(ChosenExercise(docID: fifthExercise.docID, docPath: fifthExercise.docPath, order: 4, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            lowerExercises = lowerExercises.filter{ $0 != fifthExercise}
            
            let sixthExercise = fetchExerciseWithout(K.s.skillTree.plyo, plyoExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: sixthExercise.docID, docPath: sixthExercise.docPath, order: 5, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
            plyoExercises = plyoExercises.filter{ $0 != sixthExercise}
        }
        
        if numberOfExercises == 5 {
            let firstExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, ["PUSH"])
            builtWorkout.append(ChosenExercise(docID: firstExercise.docID, docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
            upperExercises = upperExercises.filter{ $0 != firstExercise}
            
            let secondExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["SQUAT"])
            builtWorkout.append(ChosenExercise(docID: secondExercise.docID, docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            lowerExercises = lowerExercises.filter{ $0 != secondExercise}
            
            let thirdExercise = fetchExerciseWithout(K.s.skillTree.plyo, plyoExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: thirdExercise.docID, docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
            plyoExercises = plyoExercises.filter{ $0 != thirdExercise}
            
            let fourthExercise = fetchExerciseWith(K.s.skillTree.upper, upperAccessoryPool, blockID, ["PULL"])
            builtWorkout.append(ChosenExercise(docID: fourthExercise.docID, docPath: fourthExercise.docPath, order: 3, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
            upperExercises = upperExercises.filter{ $0 != fourthExercise}
            
            let fifthExercise = fetchExerciseWith(K.s.skillTree.lower, lowerAccessoryPool, blockID, ["HINGE"])
            builtWorkout.append(ChosenExercise(docID: fifthExercise.docID, docPath: fifthExercise.docPath, order: 4, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            lowerExercises = lowerExercises.filter{ $0 != fifthExercise}
        }
    }
    func makeCoreCircuit(_ numberOfExercises: Int, _ blockID: Int){ // Makes a warmup block based on PLYO
        
        if numberOfExercises == 6 {
            let firstExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: firstExercise.docID, docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != firstExercise}
            
            let secondExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: secondExercise.docID, docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != firstExercise}

            let thirdExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: thirdExercise.docID, docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != firstExercise}

            let fourthExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: fourthExercise.docID, docPath: fourthExercise.docPath, order: 3, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != firstExercise}

            let fifthExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: fifthExercise.docID, docPath: fifthExercise.docPath, order: 4, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != firstExercise}

            let sixthExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: sixthExercise.docID, docPath: sixthExercise.docPath, order: 5, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != firstExercise}
        }
        
        if numberOfExercises == 5 {
            let firstExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: firstExercise.docID, docPath: firstExercise.docPath, order: 0, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != firstExercise}
            
            let secondExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: secondExercise.docID, docPath: secondExercise.docPath, order: 1, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != firstExercise}

            let thirdExercise = fetchExerciseWithout(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: thirdExercise.docID, docPath: thirdExercise.docPath, order: 2, block: blockID, priority: thirdExercise.priority, skillTree: thirdExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != firstExercise}

            let fourthExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: fourthExercise.docID, docPath: fourthExercise.docPath, order: 3, block: blockID, priority: firstExercise.priority, skillTree: firstExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != firstExercise}

            let fifthExercise = fetchExerciseWith(K.s.skillTree.core, coreExercises, blockID, [""])
            builtWorkout.append(ChosenExercise(docID: fifthExercise.docID, docPath: fifthExercise.docPath, order: 4, block: blockID, priority: secondExercise.priority, skillTree: secondExercise.skillTree))
            coreExercises = coreExercises.filter{ $0 != firstExercise}
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

extension CircuitDayBuilder{
    
    func fetchMainExerciseWith(_ exercisePool: [FirestoreExerciseInfo]) -> FirestoreExerciseInfo{ // Returns highest level exercise from sent pool
        var chosenExercise = exercisePool[0]
        var filterPool = exercisePool
        for exercise in usedMainExercises{
            filterPool = filterPool.filter{
                $0.docPath.contains(exercise.docPath) == false
            }
        }
        if filterPool.isEmpty == false{
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
                !$0.equipment.contains("BB")
            }
        }
        if filterTag.contains("PULL"){
            exercisePool = exercisePool.filter {
                !$0.tags.contains("PULL")
            }
            exercisePool = exercisePool.filter {
                !$0.equipment.contains("BB")
            }
        }
        if filterTag.contains("SQUAT"){
            exercisePool = exercisePool.filter {
                !$0.tags.contains("SQUAT")
            }
            exercisePool = exercisePool.filter {
                !$0.equipment.contains("BB")
            }
        }
        if filterTag.contains("HINGE"){
            exercisePool = exercisePool.filter {
                !$0.tags.contains("HINGE")
            }
            exercisePool = exercisePool.filter {
                !$0.equipment.contains("BB")
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
extension CircuitDayBuilder{
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
