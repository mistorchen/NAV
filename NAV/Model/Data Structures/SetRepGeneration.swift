//
//  SetRepGeneration.swift
//  NAV
//
//  Created by Alex Chen on 7/27/23.
//

import Foundation

class SetRepGeneration{
    let userInfo: UserInfo?
    let firestoreCommands: FirestoreCommands
    let builtWorkout: [ChosenExercise]?
    
    var completeWorkout = [CompleteExerciseInfo]()
    var reps = [String:Int]()

    let group = DispatchGroup()
    
    init(userInfo: UserInfo, firestoreCommands: FirestoreCommands, builtWorkout: [ChosenExercise]) {
        self.firestoreCommands = firestoreCommands
        self.userInfo = userInfo
        self.builtWorkout = builtWorkout
        determineReps()
        
    }
    func convertToComplete(){
        for exercise in builtWorkout!{
            completeWorkout.append(CompleteExerciseInfo(docID: exercise.docID, docPath: exercise.docPath, order: exercise.order, block: exercise.block, priority: exercise.priority, skillTree: exercise.skillTree, sets: determineSets(exercise.priority), reps: reps[exercise.docID]!))
        }
    }
    
    func determineSets(_ exercisePriority: Int) -> Int{
        if exercisePriority == 3 && userInfo!.playerLevel >= 20{
            return 4
        }else{
            return 3
        }
    }
    
    
    // RUN THIS FUNCTION TO FILL var REPS BEFORE GENERATESETS
    func determineReps(){
        for exercise in builtWorkout!{
            group.enter()
            firestoreCommands.readExerciseInvenory(exercise.docID) { repHistory in
                if repHistory.contains(8888) == true{
                    
                    if exercise.priority == 3{
                        self.reps[exercise.docID] = 10
                    }else{
                        self.reps[exercise.docID] = 12
                    }
                    self.group.leave()
                }else{
                    //LOGIC FOR PROGRESSIVE OVERLOAD WITH REPHISTORY
                    //LOGIC FOR PROGRESSIVE OVERLOAD WITH REPHISTORY
                    //LOGIC FOR PROGRESSIVE OVERLOAD WITH REPHISTORY

                    self.reps[exercise.docID] = repHistory[repHistory.count - 1]
                    self.group.leave()
                }
            }
        }
        group.notify(queue: DispatchQueue.main){
            print("converting")
            self.convertToComplete()
        }
    }
}
