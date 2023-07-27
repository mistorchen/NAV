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
    let equipmentList : [String]?
    
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
                        exercises.append((FirestoreExerciseInfo(docPath: document.reference.path, priority: document["priority"] as! Int, tags: document["tags"] as! [String], level: document["level"] as! Int, equipment: document["equipment"] as! [String], skillTree: document["skillTree"] as! [String])))
                    }
                    completion(exercises)
                }
            }
        }
    }
    
    func writeProgramToFirestore(_ workout: [ChosenExercise], _ day: Int, _ currentProgramID: Int){
//        for order in 0 ..< workout.count{
//            let docRef = db.document(workout[order].docPath)
//
//            docRef.getDocument() { (document, err) in
//                if let err = err {
//                    print(err)
//                }else{
//                    if let document = document{
//                        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(currentProgramID + 1)").document("day\(day)").collection("exercises").document("\(document.documentID)").setData([
//                            "name" : document["name"] as! String,
//                            "skillTree" : document["skillTree"] as! [String],
//                            "reps" : 8,
//                            "sets" : 3,
//                            "order" : order,
//                            "block" : workout[order].block])
//                    }
//                }
//
//            }
//        }
        print("program Written")
    }
    
    func generateProgramDetails(_ currentProgramID: Int, _ totalDays: Int){
            //Sets nextProgramMade in Previous program to true and readyForNext to false
//            db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(currentProgramID)").document("programDetails").setData(["readyForNext" : false, "nextProgramMade" : true], merge: true)
//
//            let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(currentProgramID + 1)").document("programDetails")
//            for day in 1...totalDays{
//                docRef.setData(["day\(day)Completion" : 0], merge: true)
//            }
//            docRef.setData(["totalDays" : totalDays, "currentDay" : 1, "week" : 0, "readyForNext" : false, "nextProgramMade": false], merge: true)
//
        print("generate Program deets")

        }
}
