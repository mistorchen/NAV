//
//  ProgramAlgorithm.swift
//  NAV
//
//  Created by Alex Chen on 7/4/23.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

struct FirestoreCommands{
    
    let db = Firestore.firestore()
    
    let userInfo: UserInfo?
    let equipmentList = ["DB", "KB", "BENCH", "TRX", "STABILITY", "BB", "RACK", "BW", "MEDBALL", "SLED", "BOX"]
    
}

// MARK: QUERY FIRESTORE FUNCTIONS
extension FirestoreCommands{
    
    func fetchPossibleExercises(_ skillTree: String, _ skillTreeLevel: Int, _ completion: @escaping([FirestoreExerciseInfo]) -> Void){

        let docRef = db.collection("database").document("exercises").collection(skillTree).whereFilter(Filter.andFilter([
            Filter.whereField("level", isLessThanOrEqualTo: skillTreeLevel)
        ]))
            docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                if let collection = collection{
                var exercises = [FirestoreExerciseInfo]()
                    for document in collection.documents{
                        exercises.append((FirestoreExerciseInfo(docID: document.documentID, docPath: document.reference.path, priority: document["priority"] as! Int, tags: document["tags"] as! [String], level: document["level"] as! Int, equipment: document["equipment"] as! [String], skillTree: document["skillTree"] as! [String])))
                    }
                    completion(exercises)
                }
            }
        }
    }
    
    func writeProgramToFirestore(_ workout: [CompleteExerciseInfo], _ day: Int, _ currentProgramID: Int){
        print(currentProgramID)
        for order in 0 ..< workout.count{
            let docRef = db.document(workout[order].docPath)

            docRef.getDocument() { (document, err) in
                if let err = err {
                    print(err)
                }else{
                    if let document = document{
                        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(currentProgramID + 1)").document("day\(day)").collection("exercises").document("\(document.documentID)").setData([
                            "name" : document["name"] as! String,
                            "skillTree" : document["skillTree"] as! [String],
                            "reps" : workout[order].reps,
                            "sets" : workout[order].sets,
                            "order" : order,
                            "block" : workout[order].block],merge: true)
                    }
                }
            }
            let inventoryRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("exerciseInventory").document(workout[order].docID)
            inventoryRef.getDocument { document, error in
                if let error = error{
                    print(error)
                }else{
                    if document?.exists == true{
                        if let document = document{
                            var previousPrograms = document["programs"] as! [Int]
                            previousPrograms.append(currentProgramID + 1)
                            
                            var repHistory = document["repHistory"] as! [Int]
                            repHistory.append(workout[order].reps)
                            
                            inventoryRef.setData([
                                "programs" : previousPrograms,
                                "repHistory": repHistory,
                            ],merge: true)
                        }
                    }else{
                        inventoryRef.setData([
                            "programs" : [currentProgramID + 1],
                            "repHistory": [workout[order].reps],
                        ], merge: true)
                    }
                }
            }
        }
        print(day)
        for exercise in workout{
            print("\(exercise.docPath) SETS: \(exercise.sets) -- REPS: \(exercise.reps)")
        }
    }
    
    func generateProgramDetails(_ currentProgramID: Int, _ totalDays: Int){
            //Sets nextProgramMade in Previous program to true and readyForNext to false
            db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(currentProgramID)").document("programDetails").setData(["readyForNext" : false, "nextProgramMade" : true], merge: true)

            let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(currentProgramID + 1)").document("programDetails")
            for day in 1...totalDays{
                docRef.setData(["day\(day)Completion" : 0], merge: true)
            }
            docRef.setData(["totalDays" : totalDays, "currentDay" : 1, "week" : 0, "readyForNext" : false, "nextProgramMade": false], merge: true)


        }
    func readExerciseInvenory(_ docID: String, _ completion: @escaping([Int]) -> Void){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("exerciseInventory").document(docID)
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                if document?.exists == true{
                    if let document = document{
                        completion(document["repHistory"] as! [Int])
                    }
                }else{
                    completion([8888])
                }
            }
        }
    }
    
    func updateCurrentDay(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs")
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                if let document = document{
                    let currentID = document["programID"] as! Int
                    docRef.setData(["programID" : currentID + 1])
                }
            }
        }
    }
}
