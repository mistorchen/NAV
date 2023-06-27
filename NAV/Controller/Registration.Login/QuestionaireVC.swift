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

class QuestionaireVC: UIViewController{
    
    
    
    var username = ""
    var questionCount = 0
    var xpScore = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var dropdownButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var nextQuestion: UIButton!
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    
    
    @IBOutlet weak var answerTableView: UITableView!
    
    
    var age = 0
    var weight = 0
    var trainingType = 0
    var beginner = false
    var previousTraining = 0.0
    var competent = true
    
    let db = Firestore.firestore()
    
    let questions = FTSQuestionaire.Q
    
    
    override func viewDidLoad() {
//        answerTableView.register(PolarAnswerTableViewCell.nib(), forCellReuseIdentifier: PolarAnswerTableViewCell.identifier)
//        answerTableView.delegate = self
//        answerTableView.dataSource = self
        
        
        yesButton.isHidden = true
        noButton.isHidden = true
        stepper.isHidden = true
        stepperLabel.isHidden = true
        nextQuestion.isHidden = true
        stepperLabel.text = "\(stepper.value) Years"
        
        
        super.viewDidLoad()
        runQuestions()
        
        
    }
    
    
    
    func runQuestions(){
        if questionCount != questions.count{
            questionLabel.text = "\(questions[questionCount].text)"
            if questionCount == 0{
                setDropdown()
                
            }else if questionCount == 1{
                yesButton.isHidden = false
                noButton.isHidden = false
                dropdownButton.isHidden = true
                
            }else if questionCount == 2{
                yesButton.isHidden = true
                noButton.isHidden = true
                stepper.isHidden = false
                stepperLabel.isHidden = false
                nextQuestion.isHidden = false
            }else if questionCount == 3{
                yesButton.isHidden = false
                noButton.isHidden = false
                stepper.isHidden = true
                stepperLabel.isHidden = true
                nextQuestion.isHidden = true
            }
        }else{
            determineXP()
            //            self.performSegue(withIdentifier: "FTScomplete", sender: self)
        }
        
    }
    @IBAction func nextQuestionTapped(_ sender: Any) {
        questionCount += 1
        runQuestions()
    }
    @IBAction func yesTapped(_ sender: UIButton) {
        questionCount += 1
        runQuestions()
    }
    
    @IBAction func noTapped(_ sender: UIButton) {
        if questionCount == 1{
            beginner = true
            questionCount += 1
        }else if questionCount == 3{
            competent = false
        }
        questionCount += 1
        runQuestions()
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        stepperLabel.text = "\(sender.value) Years"
        previousTraining = sender.value
    }
    
    
    
    func setDropdown(){
        
        let optionClosure = {(action : UIAction) in
            if action.title == "Choose an option"{
                
            }else{
                if action.title == self.questions[self.questionCount].answerChoice[1] as! String{
                    self.trainingType = 0
                    self.nextQuestion.isHidden = false
                }else if action.title == self.questions[self.questionCount].answerChoice[2] as! String{
                    self.trainingType = 1
                    self.nextQuestion.isHidden = false
                }else if action.title == self.questions[self.questionCount].answerChoice[3] as! String{
                    self.trainingType = 2
                    self.nextQuestion.isHidden = false
                }else if action.title == self.questions[self.questionCount].answerChoice[4] as! String{
                    self.trainingType = 1
                    self.nextQuestion.isHidden = false
                }
            }
            
        }
        
        dropdownButton.menu = UIMenu(children: [
            UIAction(title: "Choose an option", state: .on, handler: optionClosure),
            UIAction(title: questions[questionCount].answerChoice[1] as! String, handler: optionClosure),
            UIAction(title: questions[questionCount].answerChoice[2] as! String, handler: optionClosure),
            UIAction(title: questions[questionCount].answerChoice[3] as! String, handler: optionClosure),
            UIAction(title: questions[questionCount].answerChoice[4] as! String, handler: optionClosure)
            
        ])
        dropdownButton.showsMenuAsPrimaryAction = true
        dropdownButton.changesSelectionAsPrimaryAction = true
    }
    
    
    //Function to determine XP Level
    func determineXP(){//} -> Int{
        var xpScore = 0
        if previousTraining > 2{
            xpScore += 1
        }else if previousTraining >= 1 && previousTraining <= 2{
            xpScore += 1
        }
        if beginner == false{
            xpScore += 1
        }
        if competent != false{
            xpScore += 1
        }
        if xpScore == 0 || xpScore == 1 {
            print("beginner")
        }else if  xpScore == 2{
            print("Intermediate")
        }else if xpScore > 2{
            print("advanced")
        }
        
        
//        findStart() // WRITE FUNCTION TO DETERMINE STARTING LEVELS
        
        setData()
        writeSkillTrees()
    }
    
    
    
    //Funtion to set the data to Firestore
    
    func setData(){
        //automatically makes a new document with Current User ID
        db.collection("users").document(Auth.auth().currentUser!.uid).setData([
            "level" : xpScore], merge: true)
        showApp()
    }
    
    func writeSkillTrees(){
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document("lower").setData(["level": 0, "exp" : 10], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document("upper").setData(["level": 0, "exp" : 20], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document("plyo").setData(["level": 0, "exp" : 30], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document("core").setData(["level": 0, "exp" : 40], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document("arms").setData(["level": 0, "exp" : 40], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).setData(["playerLevel" : 100, "trainingType" : 0], merge: true)
    }
    
    func showApp(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var  viewController: UIViewController
        viewController = storyboard.instantiateViewController(withIdentifier: "ProgramMaker")
        self.present(viewController, animated: true, completion: nil)
    }
}


extension QuestionaireVC{
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if questionCount == 0{
//            let cell = answerTableView.dequeueReusableCell(withIdentifier: PolarAnswerTableViewCell.identifier, for: indexPath) as! PolarAnswerTableViewCell
//
//            let yesGesture = UITapGestureRecognizer(target: self, action:  #selector (self.saveYes (_:)))
//            yesGesture.cancelsTouchesInView = false
//            cell.yesButton.addGestureRecognizer(yesGesture)
//questionCount += 1
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
//                self.answerTableView.reloadData()
//            }
//            return cell
//        }else if questionCount == 2{
//            let cell = answerTableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.identifier, for: indexPath) as! SliderTableViewCell
//
//            let yesGesture = UITapGestureRecognizer(target: self, action:  #selector (self.saveYes (_:)))
//            yesGesture.cancelsTouchesInView = false
//            cell.slider.addGestureRecognizer(yesGesture)
//
//            return cell
//        }
//
//        let cell = answerTableView.dequeueReusableCell(withIdentifier: PolarAnswerTableViewCell.identifier, for: indexPath) as! PolarAnswerTableViewCell
//
//        let yesGesture = UITapGestureRecognizer(target: self, action:  #selector (self.saveYes (_:)))
//        yesGesture.cancelsTouchesInView = false
//        cell.yesButton.addGestureRecognizer(yesGesture)
//
//        return cell
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    @objc func saveYes(_ sender: UITapGestureRecognizer){
//        print("yes")
//    }
    
}
