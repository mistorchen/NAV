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
        
        
      
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            for skill in self.usedSkills{
               self.calculateEXP(skill)
            }
            self.performSegue(withIdentifier: "goToHomeVC", sender: self)
            
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
        tabBar.currentDay = tabBar.currentDay + 1
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
//    func setStreak(){
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM-dd-yyyy"
//        let previousDate = formatter.string(from: Date().dayBefore)
//        let currentDate = formatter.string(from: Date())
//
//        print("\(previousDate)")
//        print("\(currentDate)")
//
//
//        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("streak").document("dates")
//        docRef.getDocument { document, error in
//            if let error = error{
//                print("error")
//            }else{
//                let dayBefore = document!["\(previousDate)"] as! Bool
//                let now = document!["\(currentDate)"] as! Bool
//
//                if dayBefore == true && now == true{
//                    let streak = document!["streak"] as! Int
//                    docRef.setData(["streak" : streak + 1], merge:true)
//                }
//            }
//        }
//
//    }

    
}

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
