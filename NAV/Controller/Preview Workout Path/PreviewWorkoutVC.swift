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
    var paths: [String : Any] = [:]
    var currentDay = 1
    var duplicate: [String] = []
    var totalDays = 0


    @IBOutlet weak var daySelector: UISegmentedControl!
    @IBOutlet weak var exerciseTable: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        readProgram()
    }
    override func viewDidLoad() {
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 165.0, green: 215.0, blue: 232.0, alpha: 100.0)]
        daySelector.setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        exerciseTable.reloadData()
        exerciseTable.register(PreviewExerciseTableViewCell.nib(), forCellReuseIdentifier: PreviewExerciseTableViewCell.identifier)
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        
        findDays()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setSegments(self.totalDays)
            self.exerciseTable.reloadData()
            super.viewDidLoad()
        }
    }
    @IBAction func daySelector(_ sender: UISegmentedControl) { // Controls the day shows by segmented bar
        exerciseTable.setContentOffset(.zero, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.exerciseTable.reloadData()
        }
        
        currentDay = sender.selectedSegmentIndex+1
        readProgram()
        
        
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
                    self.exercises.append(ExerciseInfo(name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, docID: document.documentID, block: document["block"] as! Int))
                    
                }
            }
        }
    }
    func findDays() {
        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())").document("programDetails")
        
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                self.totalDays = document!["totalDays"] as! Int
            }
        }
    }
    
    func setSegments(_ days: Int){
        daySelector.removeAllSegments()
        
        switch days{
        case 1:
            daySelector.insertSegment(withTitle: "Day 1", at: 0, animated: false)
        case 2:
            daySelector.insertSegment(withTitle: "Day 1", at: 0, animated: false)
            daySelector.insertSegment(withTitle: "Day 2", at: 1, animated: false)

        case 3:
            daySelector.insertSegment(withTitle: "Day 1", at: 0, animated: false)
            daySelector.insertSegment(withTitle: "Day 2", at: 1, animated: false)
            daySelector.insertSegment(withTitle: "Day 3", at: 2, animated: false)
        case 4:
            daySelector.insertSegment(withTitle: "Day 1", at: 0, animated: false)
            daySelector.insertSegment(withTitle: "Day 2", at: 1, animated: false)
            daySelector.insertSegment(withTitle: "Day 3", at: 2, animated: false)
            daySelector.insertSegment(withTitle: "Day 4", at: 3, animated: false)
        case 5:
            daySelector.insertSegment(withTitle: "Day 1", at: 0, animated: false)
            daySelector.insertSegment(withTitle: "Day 2", at: 1, animated: false)
            daySelector.insertSegment(withTitle: "Day 3", at: 2, animated: false)
            daySelector.insertSegment(withTitle: "Day 4", at: 3, animated: false)
            daySelector.insertSegment(withTitle: "Day 5", at: 4, animated: false)
        default:
            daySelector.insertSegment(withTitle: "Day 1", at: 0, animated: false)
            daySelector.insertSegment(withTitle: "Day 2", at: 1, animated: false)
            daySelector.insertSegment(withTitle: "Day 3", at: 2, animated: false)
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
            return 100
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
