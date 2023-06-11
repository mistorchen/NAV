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
    
    var newProgram: Bool = false
    var weeklyCheckIn: Bool = false
    
    var datesOnCalendar: [String] = []
    var streakDates: [String] = []
    let formatter = DateFormatter()
    let calendar = FSCalendar()
    
    
    override func viewDidLoad() {
        getSkillTrees()
//        testFunction()
        getProgram()
        checkForNewProgram()
        findCalendarDays()
        setStreakDays()
        
        
    }
//    func testFunction(){
//        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory")
//        docRef.getDocuments { document, error in
//            if let error = error{
//                print(error)
//            }else{
//                if document?.isEmpty == true{
//                    print("asdfsadf")
//                }
//            }
//        }
//    }

    func getSkillTrees(){
        readPlyoSkillTree()
        readCoreSkillTree()
        readLowerSkillTree()
        readUpperSkillTree()
    }
    func getProgram(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("currentProgram").document("programDetails")
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                self.totalDays = document!["totalDays"] as! Int
                self.currentDay = document!["currentDay"] as! Int
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

    func checkForNewProgram(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("currentProgram").document("programDetails")
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                self.newProgram = document!["readyForNext"] as! Bool
//
//                switch days{
//                case 1:
//                    self.dayArray.append(document!["day1Completion"] as! Int)
//                    self.newProgram = self.dayArray.allSatisfy({ $0 == 3})
//                case 2:
//                    self.dayArray.append(document!["day1Completion"] as! Int)
//                    self.dayArray.append(document!["day2Completion"] as! Int)
//                    self.newProgram = self.dayArray.allSatisfy({ $0 == 3})
//
//                case 3:
//                    self.dayArray.append(document!["day1Completion"] as! Int)
//                    self.dayArray.append(document!["day2Completion"] as! Int)
//                    self.dayArray.append(document!["day3Completion"] as! Int)
//                    self.newProgram = self.dayArray.allSatisfy({ $0 == 3})
//
//                case 4:
//                    self.dayArray.append(document!["day1Completion"] as! Int)
//                    self.dayArray.append(document!["day2Completion"] as! Int)
//                    self.dayArray.append(document!["day3Completion"] as! Int)
//                    self.dayArray.append(document!["day4Completion"] as! Int)
//                    self.newProgram = self.dayArray.allSatisfy({ $0 == 3})
//
//                case 5:
//                    self.dayArray.append(document!["day1Completion"] as! Int)
//                    self.dayArray.append(document!["day2Completion"] as! Int)
//                    self.dayArray.append(document!["day3Completion"] as! Int)
//                    self.dayArray.append(document!["day4Completion"] as! Int)
//                    self.dayArray.append(document!["day5Completion"] as! Int)
//                    self.newProgram = self.dayArray.allSatisfy({ $0 == 3})
//
//                default:
//                    print("error getCurrentDay")
//                }
            }
        }
    }
    func readDay1(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program1").document("day1").collection("exercises").order(by: "order", descending: false)
        
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
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program1").document("day2").collection("exercises").order(by: "order", descending: false)
        
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
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program1").document("day3").collection("exercises").order(by: "order", descending: false)
        
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
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program1").document("day4").collection("exercises").order(by: "order", descending: false)
        
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
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program1").document("day5").collection("exercises").order(by: "order", descending: false)
        
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
    func findCalendarDays(){
        formatter.dateFormat = "MM-dd-yyyy"
        var startDate: Date?
        let endDate: Date?
        
        if self.calendar.scope == .month{
            let indexPath = self.calendar.calculator.indexPath(for: self.calendar.currentPage, scope: .month)
            startDate = self.calendar.calculator.monthHead(forSection: (indexPath?.section)!)!
            endDate = Date()
            
            while startDate! <= endDate! {
                datesOnCalendar.append(formatter.string(from: startDate!))
                startDate! = Calendar.current.date(byAdding: .day, value: 1, to: startDate!)!
            }
            
        }
    }
}
