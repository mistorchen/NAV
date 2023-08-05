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
import Charts


class PreviewWorkoutVC: UIViewController, UITableViewDelegate{
    
    let db = Firestore.firestore()
    
    var selectedProgram: [ProgramExerciseInfo] = []

    
    var exerciseSelected = 0
    var paths: [String : Any] = [:]
    var selectedDay = 1
    var duplicate: [String] = []
    var totalDays = 0
    

    @IBOutlet weak var daySelector: UISegmentedControl!
    @IBOutlet weak var exerciseTable: UITableView!

    override func viewDidLoad() {
        let tabBar = tabBarController as! TabBarViewController
        
        selectedProgram = tabBar.day1Program
        
        exerciseTable.register(PreviewExerciseTableViewCell
            .nib(), forCellReuseIdentifier: PreviewExerciseTableViewCell.identifier)
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        
        exerciseTable.reloadData()
        
        setSegments(tabBar.totalDays)
        super.viewDidLoad()
    }
    @IBAction func daySelector(_ sender: UISegmentedControl) { // Controls the day shows by segmented bar
        exerciseTable.setContentOffset(.zero, animated: true)
        let tabBar = tabBarController as! TabBarViewController

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.exerciseTable.reloadData()
        }
        
        selectedDay = sender.selectedSegmentIndex+1
        
        switch selectedDay{
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
            print("error getProgam")
        }
    }
    
    @IBAction func updateDayButton(_ sender: UIButton) {
        let tabBar = TabBarViewController()
        let firestoreCommands = FirestoreCommands(userInfo: tabBar.userInfo)
        firestoreCommands.updateCurrentDay()
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
        daySelector.selectedSegmentIndex = 0
        
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
            return selectedProgram.count
            
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: PreviewExerciseTableViewCell.identifier, for: indexPath) as! PreviewExerciseTableViewCell
            cell.nameLabel.text = selectedProgram[indexPath.row].name
            cell.repLabel.text = "Sets: \(selectedProgram[indexPath.row].reps)"
            cell.setLabel.text = "Reps: \(selectedProgram[indexPath.row].sets)"
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            exerciseSelected = indexPath.row
            self.performSegue(withIdentifier: "viewExerciseDetails", sender: self)

        }
//        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "viewExerciseDetails"{
                let destinationVC = segue.destination as! ExerciseDetailsVC
                destinationVC.exerciseName = selectedProgram[exerciseSelected].name
                destinationVC.exerciseID = selectedProgram[exerciseSelected].docID
                
                
            }
        }
        
        
    }
