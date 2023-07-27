//
//  Achievements.swift
//  NAV
//
//  Created by Alex Chen on 6/28/23.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

struct Achievements{
    
    let db = Firestore.firestore()
    
    struct AchievementDisplay{
        var name: String?
        var description: String?
        
        init(name: String? = nil, description: String? = nil) {
            self.name = name
            self.description = description
        }
    }
    
    
    
    func testFunction(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("achievements")
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                if let collection = collection{
                    for document in collection.documents{
                        print(document.documentID)
                    }
                }
            }
        }
    }
    
}

extension Achievements{
    func checkAchievements(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("achievements")
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    switch document["type"] as! String{
                    case "reachLevel":
                        if document["unlocked"] as! Bool == false{
                            self.checkReachLevel()
                        }
                    case "workoutsComplete":
                        if document["unlocked"] as! Bool == false{
                            self.checkWorkoutsComplete()
                        }
                    default:
                        print("error")
                    }
                }
            }
        }
    }
    
    func checkReachLevel(){
        print("checkreachlevel")

        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                if let document = document{
                    let playerLevel = document["playerLevel"] as! Int

                    if playerLevel >= 10{
                        db.collection("users").document(Auth.auth().currentUser!.uid).collection("achievements").document("reachLevel10").setData(["unlocked" : true, "newAchievement" : true], merge: true)
                    }
                    if playerLevel >= 20{
                        db.collection("users").document(Auth.auth().currentUser!.uid).collection("achievements").document("reachLevel20").setData(["unlocked" : true, "newAchievement" : true], merge: true)
                    }
                    
                    
                }
            }
        }
    }
    func checkWorkoutsComplete(){
        print("checkWorkoutsComplete")

        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs")
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                if let document = document{
                    let workoutsComplete = document["workoutsComplete"] as! Int
                    if workoutsComplete >= 5{
                        db.collection("users").document(Auth.auth().currentUser!.uid).collection("achievements").document("workoutsComplete5").setData(["unlocked" : true, "newAchievement" : true], merge: true)
                    }
                }
            }
        }
    }
    func getUnlockedAchievements(_ completion: @escaping([AchievementDisplay]) -> Void){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("achievements")
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                var unlockedAchievements = [AchievementDisplay]()
                if let collection = collection{
                    for document in collection.documents{
                        unlockedAchievements.append(AchievementDisplay(name: document["name"] as! String, description: document["description"] as! String))
                    }
                    completion(unlockedAchievements)

                }
            }
        }
    }
    
    
    
    
    
    
}
