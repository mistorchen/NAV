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
    var day = 0
    var usedSkills: [String] = []
    
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        getSkills()
        updateCurrentDay()
        setStreak()
        
        
      
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            for skill in self.usedSkills{
               self.calculateEXP(skill)
            }
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        super.viewDidLoad()

        
    }
    
    func getSkills(){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection(self.findMonth()).document("day\(day)")
        
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                self.usedSkills = document!["skillTrees"] as! [String]
            }
        }
    }
    func calculateEXP(_ skill: String){
        //USE Skill Trees found in GetSkills and update the skillTrees in USER
        
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document(skill)
        
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                let exp = document!["exp"] as! Int
                docRef.setData(["exp" : exp + 20], merge: true)
            }
        }
    }
    func updateCurrentDay(){
        let tabBar = tabBarController as! TabBarViewController
        
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("currentProgram").document("programDetails")
        
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                let oldDay = tabBar.currentDay
                let completedCount = document!["day\(tabBar.currentDay)Completion"] as! Int
                var nextDay = 0
                
                if tabBar.currentDay == tabBar.totalDays{
                    nextDay = 1
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
}

extension FinishedWorkoutVC{
    func setStreak(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let previousDate = formatter.string(from: Date().dayBefore)
        let currentDate = formatter.string(from: Date())
        
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("calendar").document("streakDates")
        docRef.getDocument { document, error in
            if let error = error{
                print("error")
            }else{
                let dayBefore = document!["\(previousDate)"]
                let today = document!["\(currentDate)"]
                if today == nil{
                    if dayBefore == nil{
                        docRef.setData(["streak" : 1, currentDate : currentDate], merge:true)
                    }else{
                        let streak = document!["streak"] as! Int
                        docRef.setData(["streak" : streak + 1, currentDate : currentDate], merge:true)
                    }
                }
            }
        }
    }
}


