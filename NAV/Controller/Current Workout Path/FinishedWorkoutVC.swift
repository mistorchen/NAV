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

class FinishedWorkoutVC: UIViewController {
    
    let db = Firestore.firestore()
    var day = 0
    var usedSkills: [String] = []
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        getSkills()
        
        
        
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            for skill in self.usedSkills{
                print("asdf")
               self.calculateEXP(skill)
            }
            self.performSegue(withIdentifier: "goToHomeVC", sender: self)
            
        }
        
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
    
    
    func findMonth()-> String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return(nameOfMonth)
    }
}
