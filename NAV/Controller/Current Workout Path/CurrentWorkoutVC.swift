//
//  CurrentWorkoutVC.swift
//  NAV
//
//  Created by Alex Chen on 4/11/23.
//

import UIKit
import AVKit
import WebKit
import youtube_ios_player_helper
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class CurrentWorkoutVC: UIViewController, UITableViewDelegate, YTPlayerViewDelegate, UITextFieldDelegate{
    
    let db = Firestore.firestore()
    var exercises: [ExerciseInfo] = []
    
    var exercisePerBlock: Int = 0
    var exerciseIndex: Int = 0
    var blockIndex = 0
    var sizeOfBlocks: [Int] = [0,0,0,0]
    var programDay = 0
    var dayArray: [Int] = []
    
    var weightWritten = 0
    
    let programID = 1.1
    
    @IBOutlet weak var exerciseTable: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var blockExerciseTitle: UILabel!

    override func viewDidLoad() {
        findDay()
        clearCurrentWorkout()
        
        blockExerciseTitle.text = ""
        exerciseTable.register(CurrentWorkoutTableViewCell.nib(), forCellReuseIdentifier: CurrentWorkoutTableViewCell.identifier)
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.getWorkout()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            for i in 0...self.exercises.count-1{
                self.detBlocks(self.exercises[i].block)
            }
            self.setTitle(self.blockIndex)
            self.exerciseTable.reloadData()
        }
        
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    
    @IBAction func nextBlock(_ sender: UIButton) {
        exerciseTable.setContentOffset(.zero, animated: true)
        if blockIndex < sizeOfBlocks.count-1{
            exercisePerBlock = 0
            blockIndex += 1
            setTitle(blockIndex)
            exerciseTable.reloadData()
            
            if blockIndex == sizeOfBlocks.count-1{
                nextButton.setTitle("Complete Workout!", for: .normal)
            }
            
        }else if blockIndex == ProgramOutline.program1().blockSizes.count-1 {
            self.performSegue(withIdentifier: "goToFinishedWorkoutVC", sender: self)
            let docRef = db.document("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/programDetails")
            let completedCount = dayArray[programDay-1] + 1
            docRef.setData(["day\(programDay)Completion" : completedCount], merge: true)
        }
        
    }
    func clearCurrentWorkout(){
        let docRef = db.document("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/currentWorkout")
        docRef.delete()
    }
    func getWorkout(){
        // Reads from users monthly program based on day, default day is 1
        // Appends exercises to exercises: [ExerciseInfo] in descending order (order of program)
        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/day\(programDay)/exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.exercises.append(ExerciseInfo(name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, docID: document.documentID, block: document["block"] as! Int))
                    
                }
            }
        }
    }
    func findDay(){
        let docRef = db.document("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/programDetails")
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                
                
                // Make it based of how many days there are.
                
                
                self.dayArray = [document!["day1Completion"] as! Int, document!["day2Completion"] as! Int, document!["day3Completion"] as! Int]
                
                
                
                
                
                
                if self.dayArray[0] > self.dayArray[1]{
                    self.programDay = 2
                }else if self.dayArray[1] > self.dayArray[2]{
                    self.programDay = 3
                }else{
                    self.programDay = 1
                }
            }
        }
    }
    
    func detBlocks(_ block: Int){
        if block == 1{
            sizeOfBlocks[0] += 1
        }else if block == 2{
            sizeOfBlocks[1] += 1
        }else if block == 3{
            sizeOfBlocks[2] += 1
        }else if block == 4{
            sizeOfBlocks[3] += 1
        }else if block == 5{
            sizeOfBlocks[4] += 1
        }
    }
   
    
    func findMonth()-> String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return(nameOfMonth)
    }
    func setTitle(_ block: Int){
        blockExerciseTitle.text = "Block: \(block+1) Exercises: \(sizeOfBlocks[block])"
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
}





extension CurrentWorkoutVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sizeOfBlocks.isEmpty{
            return 0
        }
        return sizeOfBlocks[blockIndex]
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentWorkoutTableViewCell.identifier, for: indexPath) as! CurrentWorkoutTableViewCell
       
//
//        if cell.weightWritten >= exercises[exerciseIndex].sets{
//            print("\(exercises[indexPath.row].name) works")
//            nextButton.isHidden = false
//        }
        
        if exercises.isEmpty{
            exerciseTable.reloadData()
        }else if exercisePerBlock != sizeOfBlocks[blockIndex]{
            
            cell.exerciseName.text = exercises[exerciseIndex].name
            cell.repCount.text = String(exercises[exerciseIndex].reps)
            cell.setCount.text = String(exercises[exerciseIndex].sets)
            cell.YTPlayer.delegate = self
            cell.YTPlayer.load(withVideoId: "gEZbarOeI3o") // Change to read from firebase
            
            cell.dayWritePath = "/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/currentWorkout"
            cell.inventoryWritePath = "/users/\(Auth.auth().currentUser!.uid)/exerciseInventory/\(exercises[exerciseIndex].docID)"
            cell.exerciseIndex = exerciseIndex
            cell.programDay = programDay
            
            cell.set1Field.text = ""
            cell.set2Field.text = ""
            cell.set3Field.text = ""
            cell.programID = programID
            
            exerciseIndex += 1
            exercisePerBlock += 1
            
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 620
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFinishedWorkoutVC"{
            let destinationVC = segue.destination as! FinishedWorkoutVC
            destinationVC.day = programDay
        }
    }
    
    
}
