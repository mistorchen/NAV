//
//  ExerciseID.swift
//  NAV
//
//  Created by Alex Chen on 2/19/23.
//

import Foundation

struct FirestoreExerciseInfo: Equatable{ // Exercise Information Read From Firestore, Read as All Possible Exercises
    let docID: String
    let docPath: String
    let priority: Int
    let tags: [String]
    let level: Int
    let equipment: [String]
    let skillTree: [String]
}

struct ChosenExercise: Equatable{ // Exercise Data after being chosen for Built Workout, without sets or reps data
    let docID: String
    let docPath: String
    let order: Int
    let block: Int
    let priority: Int
    let skillTree: [String]
}

struct CompleteExerciseInfo{ // Chosen Exercise Information with set and rep data, ready to be written to Client Firestore Program Data
    let docID: String
    let docPath: String
    let order: Int
    let block: Int
    let priority: Int
    let skillTree: [String]
    let sets: Int
    let reps: Int
}

struct ProgramExerciseInfo {
    let docID: String
    let name: String
    let sets: Int
    let reps: Int
    let order: Int
    let block: Int
    let skillTree: [String]
}



struct BasicExerciseInfo{
    let name: String
    let level: Int
}


