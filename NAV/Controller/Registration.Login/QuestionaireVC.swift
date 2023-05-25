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

class QuestionaireVC: UIViewController {
    
    var username = ""
    var questionCount = 0
    var xpScore = 0
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var nextQuestion: UIButton!
    
    var age = 0
    var weight = 0
    var training = false
    
    
    
    let db = Firestore.firestore()
    
    let questions = FTSQuestionaire.Q
    
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runQuestions()
        
        
    }
    
    @IBAction func yesTapped(_ sender: UIButton!) {
        saveAnswer(answer: sender.titleLabel?.text! as! NSObject)
    }
    @IBAction func noTapped(_ sender: UIButton) {
        saveAnswer(answer:  sender.titleLabel?.text! as! NSObject)
    }
    @IBAction func nextQuestionTapped(_ sender: Any) {
        saveAnswer(answer: Int(slider.value) as NSObject)
    }
    
    
    func runQuestions(){
        if questionCount != questions.count{
            questionLabel.text = "\(questions[questionCount].text)"
            if questions[questionCount].answerChoice[0] as! String == "slider"{
                yesButton.isHidden = true
                noButton.isHidden = true
                nextQuestion.isHidden = false
                slider.isHidden = false
                
                slider.minimumValue = questions[questionCount].answerChoice[1] as! Float
                slider.maximumValue = questions[questionCount].answerChoice[2] as! Float
                sliderLabel.text = "\(Int(slider.value))"
                
            }else if questions[questionCount].answerChoice[0] as! String == "polar"{
                yesButton.isHidden = false
                noButton.isHidden = false
                nextQuestion.isHidden = true
                slider.isHidden = true
                sliderLabel.isHidden = true
            }else if questions[questionCount].answerChoice[0] as! String == "multiple"{
                yesButton.isHidden = true
                noButton.isHidden = true
                nextQuestion.isHidden = false
                slider.isHidden = true
                sliderLabel.isHidden = true
            }
        }else{
            determineXP()
            self.performSegue(withIdentifier: "FTScomplete", sender: self)
        }

    }
    func saveAnswer(answer: AnyObject){
        if questionCount == 0{
            age = answer as! Int
        }else if questionCount == 1{
            weight = answer as! Int
        }else if questionCount == 2{
            if answer as! String == "Yes"{
                training = true
            }
        }
        
        questionCount += 1
        runQuestions()
    }
    
    
    @IBAction func sliderValue(_ sender: UISlider) {
        sliderLabel.text = "\(Int(sender.value))"
    }
    
    //Function to determine XP Level
    func determineXP(){//} -> Int{
        xpScore = 15
        setData()
        writeSkillTrees()
    }
    
    
    
    //Funtion to set the data to Firestore
    
    func setData(){
        //automatically makes a new document with Current User ID
        db.collection("users").document(Auth.auth().currentUser!.uid).setData([
            "level" : xpScore,
            //"population" : "general"
        ], merge: true)
    }
    func writeSkillTrees(){
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document("lower").setData(["exp" : 10], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document("upper").setData(["exp" : 20], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document("plyo").setData(["exp" : 30], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document("core").setData(["exp" : 40], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document("arms").setData(["exp" : 40], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).setData(["playerLevel" : 100, "trainingType" : 0], merge: true)
    }
    
    
}
