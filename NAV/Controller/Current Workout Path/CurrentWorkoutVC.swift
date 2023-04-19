//
//  CurrentWorkoutVC.swift
//  NAV
//
//  Created by Alex Chen on 4/11/23.
//

import UIKit
import AVKit
import youtube_ios_player_helper
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class CurrentWorkoutVC: UIViewController, UITableViewDelegate, YTPlayerViewDelegate{
    
    let db = Firestore.firestore()
    var exercises: [ExerciseInfo] = []
    var exerciseIndex: Int = 0
    var blockIndex = 0
    var sizeOfBlocks: [Int] = [0,0,0,0,0]
    
    @IBOutlet weak var exerciseTable: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        getWorkout()
        
        exerciseTable.register(CurrentWorkoutTableViewCell.nib(), forCellReuseIdentifier: CurrentWorkoutTableViewCell.identifier)
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            for i in 0...self.exercises.count-1{
                self.detBlocks(self.exercises[i].block)
            }
            
        }
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.exerciseTable.reloadData()
            
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    
    @IBAction func nextBlock(_ sender: UIButton) {
        exerciseTable.setContentOffset(.zero, animated: true)
        if blockIndex < ProgramOutline.program1().blockSizes.count-1{
            blockIndex += 1
            exerciseTable.reloadData()
            
            if blockIndex == ProgramOutline.program1().blockSizes.count-1 {
                nextButton.setTitle("Complete Workout!", for: .normal)
            }
            
        }else if blockIndex == ProgramOutline.program1().blockSizes.count-1 {
            self.performSegue(withIdentifier: "goToFinishedWorkoutVC", sender: self)
        }
        
    }
    
    func getWorkout(){
        
        // Reads from users monthly program based on day, default day is 1
        // Appends exercises to exercises: [ExerciseInfo] in descending order (order of program)
        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/day\(1)/exercises").order(by: "order", descending: false)
        
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
        if exercises.isEmpty{
            exerciseTable.reloadData()
        }else{
            
            cell.exerciseName.text = exercises[exerciseIndex].name
            cell.repCount.text = String(exercises[exerciseIndex].reps)
            cell.setCount.text = String(exercises[exerciseIndex].sets)
            cell.YTPlayer.delegate = self
            cell.YTPlayer.load(withVideoId: "gEZbarOeI3o")
            cell.dayWritePath = "/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/day\(1)/exercises"
            cell.exerciseWritePath = "/\(exercises[exerciseIndex].docID)"
            
            if exerciseIndex != exercises.count-1{
                exerciseIndex += 1
            }
            
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 620
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "viewMoreDetails"{
//            let destinationVC = segue.destination as! MoreExeriseDetails
//            destinationVC.exerciseName = exercises[exerciseSelected].name
//        }
    }
    
    
}
