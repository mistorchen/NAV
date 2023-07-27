//
//  FinishedWorkoutVC.swift
//  NAV
//
//  Created by Alex Chen on 4/12/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FSCalendar

class FinishedWorkoutVC: UIViewController{
    
    let db = Firestore.firestore()
    var programID = 0
    var day = 0
    var usedSkills: [String] = []
    
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        setVariables()
        getSkills()
        updateCurrentDay()
        setStreak()
        clearCurrentWorkout()
        updateWorkoutCount()
        
      
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            for skill in self.usedSkills{
               self.calculateSkillEXP(skill)
            }
            self.showTabController()
        }
        super.viewDidLoad()

        
    }
    func setVariables(){
        let tabBar = tabBarController as! TabBarViewController
        day = tabBar.currentDay
        programID = tabBar.programID
    }
    
    func getSkills(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(programID)").document("day\(day)").collection("exercises")
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.usedSkills = self.usedSkills + (document["skillTree"] as! [String])
                }
            }
        }
    }
    func calculateSkillEXP(_ skill: String){
        //USE Skill Trees found in GetSkills and update the skillTrees in USER
        
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document(skill)
        
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                let exp = document!["exp"] as! Int
                let currentLevel = document!["level"] as! Int
                let expAdded = SkillLevelEXP.skillLevelUp(currentLevel, exp)
                docRef.setData(["level" : expAdded[0], "exp" : expAdded[1]], merge: true)
            }
        }
    }
    
    func updatePlayerEXP(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document("player")
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                if let document = document{
                        let exp = document["exp"] as! Int
                        let currentLevel = document["level"] as! Int
                        let expAdded = SkillLevelEXP.playerLevelUp(currentLevel, exp)
                        docRef.setData(["level" : expAdded[0], "exp" : expAdded[1]], merge: true)
                }
            }
        }
    }
    
    
    
    
    
    
    func updateCurrentDay(){
        let tabBar = tabBarController as! TabBarViewController
        
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(programID)").document("programDetails")
        
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                let oldDay = tabBar.currentDay
                let completedCount = document!["day\(tabBar.currentDay)Completion"] as! Int
                let nextProgramMade = document!["nextProgramMade"] as! Bool
                if completedCount == 3 && nextProgramMade == false{
                    docRef.setData(["readyForNext" : true], merge: true)
                }
                
                var nextDay = 0
                
                if tabBar.currentDay == tabBar.totalDays{
                    nextDay = 1
                    
                    //Updates Week
                    self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").setData(["week" : tabBar.week + 1])
                    
                    //Updates to New Program
                    if completedCount == 3 && nextProgramMade == true{
                        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").setData(["programID" : self.programID + 1])
                    }
                    
                }else{
                    nextDay = tabBar.currentDay + 1
                }
                tabBar.currentDay = nextDay

                docRef.setData(["currentDay" : nextDay, "day\(oldDay)Completion" : completedCount + 1], merge: true)
                
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
    func clearCurrentWorkout(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(programID)").document("currentWorkout")
        docRef.delete()
    }
    
}

extension FinishedWorkoutVC{
    func updateWorkoutCount(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs")
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                if let document = document{
                    let workoutsCompletedOld = document["workoutsComplete"] as! Int
                    docRef.setData(["workoutsComplete" : workoutsCompletedOld + 1], merge: true)
                }
            }
        }
    }
    
    func setStreak(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let previousDate = formatter.string(from: Date().dayBefore)
        let currentDate = formatter.string(from: Date())
        
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("calendar").document("streakDates")
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                let dayBefore = document!["\(previousDate)"]
                let today = document!["\(currentDate)"]
                if today == nil{
                    if dayBefore == nil{
                        docRef.setData(["streak" : 1, currentDate : currentDate], merge: true)
                    }else{
                        let streak = document!["streak"] as! Int
                        docRef.setData(["streak" : streak + 1, currentDate : currentDate], merge: true)
                    }
                }
            }
        }
    }
    
    func showTabController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var  viewController: UIViewController
        viewController = storyboard.instantiateViewController(withIdentifier: "TabController")
        self.present(viewController, animated: true, completion: nil)
    }
}


