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
import FSCalendar


class TabBarViewController: UITabBarController{
    let db = Firestore.firestore()
    
    
    //User Info Variables
    var levels: [String : Int] = [:]
    var userInfo: UserInfo?
    let selectedTree = [K.s.skillTree.upper, K.s.skillTree.lower, K.s.skillTree.plyo, K.s.skillTree.core, K.s.skillTree.arms]
    
    // Skill Tree Variables
    var plyoSkillTree: [BasicExerciseInfo] = []
    var upperSkillTree: [BasicExerciseInfo] = []
    var lowerSkillTree: [BasicExerciseInfo] = []
    var coreSkillTree: [BasicExerciseInfo] = []
    
    
    //Program Variables
    var totalDays = Int()
    var dayArray = [Int]()
    var currentDay = Int()
    var programID = Int()
    var newProgram = Bool()
    var week = Int()
    
    var day1Program: [ProgramExerciseInfo] = []
    var day2Program: [ProgramExerciseInfo] = []
    var day3Program: [ProgramExerciseInfo] = []
    var day4Program: [ProgramExerciseInfo] = []
    var day5Program: [ProgramExerciseInfo] = []
    
    //Check In Variables
    var weeklyCheckIn: Bool = false
    
    
    //Calendar Variables
    var datesOnCalendar: [String] = []
    var streakDates: [String] = []
    var scheduleDates: [String] = []
    var streak: Int?
    let formatter = DateFormatter()
    let calendar = FSCalendar()
    
    
    override func viewDidLoad() {
        isNewUser()
        
    }
   func isNewUser(){
       let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
       docRef.getDocument { document, error in
           if let error = error{
               print(error)
           }else{
               if document?.exists == false {
                   self.registerUser()
               }else{
                   self.getUserInfo()
                   self.getSkillTrees()
                   self.getProgram()
           //        checkForNewProgram()
                   self.findCalendarDays()
                   self.setStreakDays()
                   self.setScheduleDays()
               }
           }
       }
}
    func registerUser(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController
        viewController = storyboard.instantiateViewController(withIdentifier: "InfoSetUp")
        self.present(viewController, animated: true, completion: nil)
    }

    func getSkillTrees(){
        readPlyoSkillTree()
        readCoreSkillTree()
        readLowerSkillTree()
        readUpperSkillTree()
    }
    func getProgram(){
        let programIDREF = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs")
        programIDREF.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                if let document = document{
                    self.programID = document["programID"] as! Int
                    let docRef = self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(self.programID)").document("programDetails")
                    docRef.getDocument { document, error in
                        if let error = error{
                            print(error)
                        }else{
                            self.totalDays = document!["totalDays"] as! Int
                            self.currentDay = document!["currentDay"] as! Int
                            self.newProgram = document!["readyForNext"] as! Bool
                            self.week = document!["week"] as! Int
                            switch self.totalDays{
                            case 1:
                                self.readDay1()
                            case 2:
                                self.readDay1()
                                self.readDay2()
                            case 3:
                                self.readDay1()
                                self.readDay2()
                                self.readDay3()
                                
                            case 4:
                                self.readDay1()
                                self.readDay2()
                                self.readDay3()
                                self.readDay4()
                            case 5:
                                self.readDay1()
                                self.readDay2()
                                self.readDay3()
                                self.readDay4()
                                self.readDay5()
                            default:
                                print("error getProgam")
                            }
                        }
                    }
                }
            }
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
// MARK: CHANGE THIS FUNCTION TO DETERMINE IF THE USER NEEDS A NEW PROGRAM

//    func checkForNewProgram(){
//        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(currentProgram)").document("programDetails")
//        docRef.getDocument { document, error in
//            if let error = error{
//                print(error)
//            }else{
////
////                switch days{
////                case 1:
////                    self.dayArray.append(document!["day1Completion"] as! Int)
////                    self.newProgram = self.dayArray.allSatisfy({ $0 == 3})
////                case 2:
////                    self.dayArray.append(document!["day1Completion"] as! Int)
////                    self.dayArray.append(document!["day2Completion"] as! Int)
////                    self.newProgram = self.dayArray.allSatisfy({ $0 == 3})
////
////                case 3:
////                    self.dayArray.append(document!["day1Completion"] as! Int)
////                    self.dayArray.append(document!["day2Completion"] as! Int)
////                    self.dayArray.append(document!["day3Completion"] as! Int)
////                    self.newProgram = self.dayArray.allSatisfy({ $0 == 3})
////
////                case 4:
////                    self.dayArray.append(document!["day1Completion"] as! Int)
////                    self.dayArray.append(document!["day2Completion"] as! Int)
////                    self.dayArray.append(document!["day3Completion"] as! Int)
////                    self.dayArray.append(document!["day4Completion"] as! Int)
////                    self.newProgram = self.dayArray.allSatisfy({ $0 == 3})
////
////                case 5:
////                    self.dayArray.append(document!["day1Completion"] as! Int)
////                    self.dayArray.append(document!["day2Completion"] as! Int)
////                    self.dayArray.append(document!["day3Completion"] as! Int)
////                    self.dayArray.append(document!["day4Completion"] as! Int)
////                    self.dayArray.append(document!["day5Completion"] as! Int)
////                    self.newProgram = self.dayArray.allSatisfy({ $0 == 3})
////
////                default:
////                    print("error getCurrentDay")
////                }
//            }
//        }
//    }
    func readDay1(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(self.programID)").document("day1").collection("exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.day1Program.append(ProgramExerciseInfo(docID: document.documentID, name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, block: document["block"] as! Int, skillTree: document["skillTree"] as! [String]))
                    
                }
            }
        }
    }
    func readDay2(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(self.programID)").document("day2").collection("exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.day2Program.append(ProgramExerciseInfo(docID: document.documentID, name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, block: document["block"] as! Int, skillTree: document["skillTree"] as! [String]))
                    
                }
            }
        }
    }
    func readDay3(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(self.programID)").document("day3").collection("exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.day3Program.append(ProgramExerciseInfo(docID: document.documentID, name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, block: document["block"] as! Int, skillTree: document["skillTree"] as! [String]))
                    
                }
            }
        }
    }
    func readDay4(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(self.programID)").document("day4").collection("exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.day4Program.append(ProgramExerciseInfo(docID: document.documentID, name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, block: document["block"] as! Int, skillTree: document["skillTree"] as! [String]))
                    
                }
            }
        }
    }
    func readDay5(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(self.programID)").document("day5").collection("exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.day5Program.append(ProgramExerciseInfo(docID: document.documentID, name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, block: document["block"] as! Int, skillTree: document["skillTree"] as! [String]))
                    
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

// MARK: Calendar Data Functions
extension TabBarViewController{
    func setStreakDays(){
        
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("calendar").document("streakDates")
        docRef.getDocument { document, error in
            if let error = error{
                print("error")
            }else{
                if self.datesOnCalendar.isEmpty{
                    self.setStreakDays()
                }else{
                    for day in self.datesOnCalendar{
                        if document!["\(day)"] != nil{
                            self.streakDates.append(day)
                        }
                    }
                    
                }
            }
        }
    }
    func setScheduleDays(){
        
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("calendar").document("schedule")
        docRef.getDocument { document, error in
            if let error = error{
                print("error")
            }else{

                    for day in self.datesOnCalendar{
                        if document!["\(day)"] != nil{
                            self.scheduleDates.append(day)
                        }
                    }
            }
        }
    }
    func findCalendarDays(){
        formatter.dateFormat = "MM-dd-yyyy"
        var startDate: Date?
        let endDate: Date?
        
        if self.calendar.scope == .month{
            startDate = Date().startOfMonthDate
            endDate = Date().endOfMonthDate
            
            while startDate! <= endDate! {
                datesOnCalendar.append(formatter.string(from: startDate!))
                startDate! = Calendar.current.date(byAdding: .day, value: 1, to: startDate!)!
            }
            
        }
    }
}

// MARK: GET USER INFO FUNCTION
extension TabBarViewController{
    func getUserInfo(){
        let docRef = db.collection(K.s.users).document(K.db.userAuth)
        docRef.getDocument { document, err in
            if let err = err{
                print(err)
            }else{
                if let document = document{
                    self.levels[K.s.skillTree.trainingType] = document[K.s.skillTree.trainingType] as! Int

                }
            }
        }
        let skillTreeRef = db.collection(K.s.users).document(K.db.userAuth).collection(K.s.skillTree.skillTree)
        
        skillTreeRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                if let collection = collection{
                    for document in collection.documents{
                        self.levels[document.documentID] = document["level"] as! Int
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.userInfo = UserInfo(
                playerLevel: self.levels[K.s.skillTree.player]!,
                trainingType: self.levels[K.s.skillTree.trainingType]!,
                upperLevel: self.levels[K.s.skillTree.upper]!,
                lowerLevel: self.levels[K.s.skillTree.lower]!,
                plyoLevel: self.levels[K.s.skillTree.plyo]!,
                coreLevel: self.levels[K.s.skillTree.core]!,
                armsLevel: self.levels[K.s.skillTree.arms]!)
                
        }
        
        
    }
}


