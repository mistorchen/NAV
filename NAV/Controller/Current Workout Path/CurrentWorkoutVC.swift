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
    var selectedProgram: [ExerciseInfo] = []
    
    var exercisePerBlock: Int = 0
    var exerciseIndex: Int = 0
    var blockIndex = 0
    var sizeOfBlocks: [Int] = [0,0,0,0]
    var currentDay = 0
    var dayArray: [Int] = []
    var completedCount = 1
    var weightWritten = 0
    
    let programID = 1.1
    
    @IBOutlet weak var exerciseTable: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var blockExerciseTitle: UILabel!

    override func viewDidLoad() {
        
        clearCurrentWorkout()
        setSelectedProgram()
        blockExerciseTitle.text = ""
        exerciseTable.register(CurrentWorkoutTableViewCell.nib(), forCellReuseIdentifier: CurrentWorkoutTableViewCell.identifier)
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            for count in 0...self.selectedProgram.count-1{
                self.detBlocks(self.selectedProgram[count].block)
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
            docRef.getDocument { document, error in
                if let error = error{
                    print("error")
                }else{
                    self.completedCount = document!["day\(self.currentDay)Completion"] as! Int
                    docRef.setData(["day\(self.currentDay)Completion" : self.completedCount + 1], merge: true)
                }
            }
        }
        
    }
    
    
    func clearCurrentWorkout(){
        let docRef = db.document("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/currentWorkout")
        docRef.delete()
    }
    
    func setSelectedProgram(){
        let tabBar = tabBarController as! TabBarViewController
        currentDay = tabBar.currentDay
        switch tabBar.currentDay{
        case 1:
            selectedProgram = tabBar.day1Program
        case 2:
            selectedProgram = tabBar.day2Program
        case 3:
            selectedProgram = tabBar.day3Program
        case 4:
            selectedProgram = tabBar.day4Program
        case 5:
            selectedProgram = tabBar.day5Program
        default:
            setSelectedProgram()
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
    
//    func getWorkout(){
//        // Reads from users monthly program based on day, default day is 1
//        // Appends exercises to exercises: [ExerciseInfo] in descending order (order of program)
//        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/day\(programDay)/exercises").order(by: "order", descending: false)
//
//        docRef.getDocuments { collection, error in
//            if let error = error{
//                print(error)
//            }else{
//                for document in collection!.documents{
//                    self.selectedProgram.append(ExerciseInfo(name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, docID: document.documentID, block: document["block"] as! Int))
//
//                }
//            }
//        }
//    }
    
    
    
   
    
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
        
        if selectedProgram.isEmpty{
            exerciseTable.reloadData()
        }else if exercisePerBlock != sizeOfBlocks[blockIndex]{
            
            cell.exerciseName.text = selectedProgram[exerciseIndex].name
            cell.repCount.text = String(selectedProgram[exerciseIndex].reps)
            cell.setCount.text = String(selectedProgram[exerciseIndex].sets)
            cell.YTPlayer.delegate = self
            cell.YTPlayer.load(withVideoId: "gEZbarOeI3o") // Change to read from firebase
            
            cell.dayWritePath = "/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/currentWorkout"
            cell.inventoryWritePath = "/users/\(Auth.auth().currentUser!.uid)/exerciseInventory/\(selectedProgram[exerciseIndex].docID)"
            cell.exerciseIndex = exerciseIndex
            cell.programDay = currentDay
            
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
            destinationVC.day = currentDay
        }
    }
    
    
}
