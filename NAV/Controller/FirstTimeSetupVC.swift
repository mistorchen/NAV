//
//  FirstTimeSetupVC.swift
//  NAV
//
//  Created by Alex Chen on 2/9/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirstTimeSetupVC: UIViewController {
    
    var username = ""
    var questionCount = 0
    var xpScore = 0
    @IBOutlet weak var yesTapped: UIButton!
    @IBOutlet weak var noTapped: UIButton!
    
    let db = Firestore.firestore()
    
    let questions = FTSQuestionaire.Q
    
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = "\(questions[0])"
        
        
        
        
    }
    
    @IBAction func yesTapped(_ sender: UIButton!) {
        xpScore+=1
        
        if questionCount < questions.count-1{
            
            questionCount+=1
            print(questionCount)
            questionLabel.text = questions[questionCount]
        }else{
            determineXP()
            
        }
    }
    
    
    //Function to determine XP Level
    func determineXP(){//} -> Int{
        print("Success")
        setData()
    }
    
    
    
    //Funtion to set the data to Firestore
    
    func setData(){
        //automatically makes a new document with Current User ID
        db.collection("users").document(Auth.auth().currentUser!.uid).setData([
            "username" : username,
            "level" : xpScore,
            //"population" : "general"
        ])
    }
    
    
}
