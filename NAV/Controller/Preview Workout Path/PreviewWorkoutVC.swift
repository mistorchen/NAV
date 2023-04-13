//
//  WorkoutVC.swift
//  NAV
//
//  Created by Alex Chen on 2/9/23.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class PreviewWorkoutVC: UIViewController, UITableViewDelegate{
    
    let db = Firestore.firestore()
    
    var exercises: [ExerciseInfo] = []
    var tempExercises: [ExerciseInfo] = []
    var exerciseSelected = 0
    var exerciseCount = 9
    var paths: [String : Any] = [:]
    var currentDay = 1
    var duplicate: [String] = []
    


    @IBOutlet weak var exerciseTable: UITableView!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        
        exerciseTable.reloadData()
        exerciseTable.register(PreviewExerciseTableViewCell.nib(), forCellReuseIdentifier: PreviewExerciseTableViewCell.identifier)
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        readProgram()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.exerciseTable.reloadData()
        }
        
        
        
        
        super.viewDidLoad()
    }
    
    @IBAction func newProgram(_ sender: UIButton){ // Uses button to write a new program. Runs from index through exerciseCount(DEFAULTED)
        for day in 1...4{
            duplicate = []
            for index in 0...exerciseCount{
                writeExercise(index: index, day: day)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.exerciseTable.reloadData()
        }
    }
    
    @IBAction func readTapped(_ sender: UIButton) { // Uses Button to read existing monthly program
        readProgram()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.exerciseTable.reloadData()
            
        }
        
    }
    @IBAction func daySelector(_ sender: UISegmentedControl) { // Controls the day shows by segmented bar
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.exerciseTable.reloadData()
        }
        
        currentDay = sender.selectedSegmentIndex+1
        readProgram()
        
        
    }

    
    // MARK: Read Exercise Database
    func writeExercise(index: Int, day: Int) {
        
        // Reads path from program outline
        // Selects a random document in collection
        // Writes selected document(exercise) to users monthly program
        // Repeats for each day (DEFAULTED)
        
        let program = ProgramOutline.program1()
        let docRef = db.collection(program.paths[index]!)
        
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                if let document = querySnapshot!.documents.randomElement() {
                    if self.checkDuplicate(docID: document.documentID, day: day, index: index) == false{
                        //                    self.exercises.append(ExerciseInfo(name: document["name"] as! String, level: document["level"] as! Int, docPath: "\(docRef.path)/\(document.documentID)"))
                        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection(self.findMonth()).document("day\(day)").collection("exercises").document("\(document.documentID)").setData([
                            "name" : document["name"] as! String,
                            "reps" : SetRepGeneration.generateReps(),
                            "sets" : SetRepGeneration.generateSets(),
                            "order" : index,
                            
                        ])
                    }else{
                        self.writeExercise(index: index, day: day)
                    }
                }
            }
            
        }
    }
    func checkDuplicate(docID: String, day: Int, index: Int) -> Bool{ //Checks for duplicates
        
        // Appends exercise docID to duplicate array
        //if duplicate = false, proceedes with firestore write
        //if duplicate = true, reruns func writeExercise
        if duplicate.count == 0{
            duplicate.append(docID)
            return false
        }else{
            for name in duplicate{
                if docID == name{
                    print("\(docID), \(day), \(index)")

                    return true
                }else{
                    duplicate.append(docID)
                    return false
                }
            }
        }
        return true
    }
        
    
    func readProgram(){
        
        // Reads from users monthly program based on day, default day is 1
        // Appends exercises to exercises: [ExerciseInfo] in descending order (order of program)
        exercises = []
        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/day\(currentDay)/exercises").order(by: "order", descending: false)
        
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.exercises.append(ExerciseInfo(name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, docID: document.documentID))
                    
                }
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


// MARK: Table View Sender
    extension PreviewWorkoutVC: UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return exercises.count
            
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: PreviewExerciseTableViewCell.identifier, for: indexPath) as! PreviewExerciseTableViewCell
            cell.nameLabel.text = exercises[indexPath.row].name
            cell.repCount.text = "\(exercises[indexPath.row].reps)"
            cell.setCount.text = "\(exercises[indexPath.row].sets)"
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            exerciseSelected = indexPath.row
            self.performSegue(withIdentifier: "viewMoreDetails", sender: self)

        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "viewMoreDetails"{
                let destinationVC = segue.destination as! MoreExeriseDetails
                destinationVC.exerciseName = exercises[exerciseSelected].name
            }
        }
        
        
    }
