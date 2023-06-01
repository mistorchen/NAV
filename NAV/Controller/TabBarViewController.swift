//
//  TabBarViewController.swift
//  NAV
//
//  Created by Alex Chen on 5/29/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


class TabBarViewController: UITabBarController{
    let db = Firestore.firestore()
    
    var day1Program: [ExerciseInfo] = []
    var day2Program: [ExerciseInfo] = []
    var day3Program: [ExerciseInfo] = []
    var day4Program: [ExerciseInfo] = []
    var day5Program: [ExerciseInfo] = []
    
    var plyoSkillTree: [BasicExerciseInfo] = []
    var upperSkillTree: [BasicExerciseInfo] = []
    var lowerSkillTree: [BasicExerciseInfo] = []
    var coreSkillTree: [BasicExerciseInfo] = []
    
    var totalDays = 0
    var dayArray:[Int] = []
    var currentDay = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        findCurrentWorkout(self.totalDays)
    }
    
    
    override func viewDidLoad() {
        getProgramDetails()
        getSkillTrees()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.getProgram(self.totalDays)
            self.findCurrentWorkout(self.totalDays)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){

        }
        
        
    }
    
    func getProgramDetails(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("\(findMonth())").document("programDetails")
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                self.totalDays = document!["totalDays"] as! Int
            }
        }
    }
    func getSkillTrees(){
        readPlyoSkillTree()
        readCoreSkillTree()
        readLowerSkillTree()
        readUpperSkillTree()
    }
    func getProgram(_ days: Int){
        switch days{
        case 1:
            readDay1()
        case 2:
            readDay1()
            readDay2()
        case 3:
            readDay1()
            readDay2()
            readDay3()
            
        case 4:
            readDay1()
            readDay2()
            readDay3()
            readDay4()
        case 5:
            readDay1()
            readDay2()
            readDay3()
            readDay4()
            readDay5()
        default:
            print("error getProgam")
        }
    }
    
   
    
    
    func findMonth()-> String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return(nameOfMonth)
    }
}
// MARK: READ DAY PROGRAM FUNCTIONS
extension TabBarViewController{
    
    
    func findCurrentWorkout(_ days: Int){
        let docRef = db.document("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/programDetails")
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                
                
                switch days{
                case 1:
                    self.dayArray.append(document!["day1Completion"] as! Int)
                    self.currentDay = 1
                case 2:
                    self.dayArray.append(document!["day1Completion"] as! Int)
                    self.dayArray.append(document!["day2Completion"] as! Int)
                    if self.dayArray[0] > self.dayArray[1]{
                        self.currentDay = 2
                    }else{
                        self.currentDay = 1
                    }
                case 3:
                    self.dayArray.append(document!["day1Completion"] as! Int)
                    self.dayArray.append(document!["day2Completion"] as! Int)
                    self.dayArray.append(document!["day3Completion"] as! Int)
                    if self.dayArray[0] > self.dayArray[1]{
                        self.currentDay = 2
                    }else if self.dayArray[1] > self.dayArray[2]{
                        self.currentDay = 3
                    }else{
                        self.currentDay = 1
                    }
                case 4:
                    self.dayArray.append(document!["day1Completion"] as! Int)
                    self.dayArray.append(document!["day2Completion"] as! Int)
                    self.dayArray.append(document!["day3Completion"] as! Int)
                    self.dayArray.append(document!["day4Completion"] as! Int)
                    if self.dayArray[0] > self.dayArray[1]{
                        self.currentDay = 2
                    }else if self.dayArray[1] > self.dayArray[2]{
                        self.currentDay = 3
                    }else if self.dayArray[2] > self.dayArray[3]{
                        self.currentDay = 4
                    }else{
                        self.currentDay = 1
                    }
                case 5:
                    self.dayArray.append(document!["day1Completion"] as! Int)
                    self.dayArray.append(document!["day2Completion"] as! Int)
                    self.dayArray.append(document!["day3Completion"] as! Int)
                    self.dayArray.append(document!["day4Completion"] as! Int)
                    self.dayArray.append(document!["day5Completion"] as! Int)
                    if self.dayArray[0] > self.dayArray[1]{
                        self.currentDay = 2
                    }else if self.dayArray[1] > self.dayArray[2]{
                        self.currentDay = 3
                    }else if self.dayArray[2] > self.dayArray[3]{
                        self.currentDay = 4
                    }else if self.dayArray[3] > self.dayArray[4]{
                        self.currentDay = 5
                    }else{
                        self.currentDay = 1
                    }
                default:
                    print("error getCurrentDay")
                }
            }
        }
    }
    func readDay1(){
        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/day\(1)/exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.day1Program.append(ExerciseInfo(name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, docID: document.documentID, block: document["block"] as! Int))
                    
                }
            }
        }
    }
    func readDay2(){
        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/day\(2)/exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.day2Program.append(ExerciseInfo(name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, docID: document.documentID, block: document["block"] as! Int))
                    
                }
            }
        }
    }
    func readDay3(){
        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/day\(3)/exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.day3Program.append(ExerciseInfo(name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, docID: document.documentID, block: document["block"] as! Int))
                    
                }
            }
        }
    }
    func readDay4(){
        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/day\(4)/exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.day4Program.append(ExerciseInfo(name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, docID: document.documentID, block: document["block"] as! Int))
                    
                }
            }
        }
    }
    func readDay5(){
        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/day\(5)/exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.day5Program.append(ExerciseInfo(name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, docID: document.documentID, block: document["block"] as! Int))
                    
                }
            }
        }
    }
}

// MARK: READ SKILL TREE FUNCTIONS
extension TabBarViewController{
    func readPlyoSkillTree(){
        let docRef = db.collection(dK.skillTree.plyo).order(by: "level", descending: false)
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.plyoSkillTree.append(BasicExerciseInfo(name: document["name"] as! String, level: document["level"] as! Int))
                }
            }
        }
    }
    func readCoreSkillTree(){
        let docRef = db.collection(dK.skillTree.core).order(by: "level", descending: false)
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.coreSkillTree.append(BasicExerciseInfo(name: document["name"] as! String, level: document["level"] as! Int))
                }
            }
        }
    }
    func readLowerSkillTree(){
        let docRef = db.collection(dK.skillTree.lower).order(by: "level", descending: false)
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.lowerSkillTree.append(BasicExerciseInfo(name: document["name"] as! String, level: document["level"] as! Int))
                }
            }
        }
    }
    func readUpperSkillTree(){
        let docRef = db.collection(dK.skillTree.upper).order(by: "level", descending: false)
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.upperSkillTree.append(BasicExerciseInfo(name: document["name"] as! String, level: document["level"] as! Int))
                }
            }
        }
    }
}
