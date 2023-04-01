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


class CurrentWorkoutVC: UIViewController, UITableViewDelegate{
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var exerciseTable: UITableView!
    var exercises: [ExerciseInfo] = []
    var tempExercises: [ExerciseInfo] = []
    var exerciseSelected = 0
    var exerciseCount = 0
    var paths: [String : Any] = [:]

    
    override func viewDidLoad() {
        
        exerciseTable.reloadData()
        exerciseTable.register(UINib(nibName: "ExerciseTableViewCell", bundle: nil), forCellReuseIdentifier: "ExerciseTableCell")
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        readProgram()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.exerciseTable.reloadData()
        }
        
        
        
        
        super.viewDidLoad()
    }
    
    @IBAction func newProgram(_ sender: UIButton) {
        exercises = []
        tempExercises = []
        getCollectionDocs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.exerciseTable.reloadData()
        }
        
    }
    
    @IBAction func readTapped(_ sender: UIButton) {
        readProgram()
        
        
    }

    
    // MARK: Read Exercise Database
    func getCollectionDocs(){
        
        let program = ProgramOutline.program1()
        
        for counter in 1 ... program.exerciseCount{ // Reads the database x times: x = exercise count determined by program
        
            let docRef = db.collection(program.paths[counter]!)
            
            //Sets field constraints for querying
//            docRef.whereField("index", isEqualTo: Int.random(in: 0...1)).limit(to: 1)
            

            docRef.getDocuments { (collection, error) in
                if let error = error{
                    print(error)
                }else {
// reads every document in collection according to field constraint. Stores in TEMP Exercises
                    for document in collection!.documents{
                        self.tempExercises.append(ExerciseInfo(name: document["name"] as! String, youtube: document["youtube"] as! String, difficulty: document["difficulty"] as! Int, docID: document.documentID))
                    }
                }
                if let transferData = self.tempExercises.randomElement(){ // Picks a random element from TempExercises and stores it in Exercises. Exercises is displayed later
                    
                    self.exercises.append(ExerciseInfo(name: transferData.name, youtube: transferData.youtube, difficulty: transferData.difficulty, docID: transferData.docID))

                    print(counter)
                    self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("march").document("day1").setData(["e\(counter)" : "\(program.paths[counter]!)/\(transferData.docID)"], merge: true)                    //SAVES DOCUMENT PATH TO USER MONTHLY PROGRAM - DEFAULT MARHCH
                    print(transferData.docID)

                    
                    
                }
                
            } // End of Closure
        }
    }
    
    func readProgram(){
        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/march")
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.paths = document.data()
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.setTable()
        }
    }
        
    func setTable(){
        for i in stride(from: 1, through: paths.count, by: 1){
            let docRef = db.document(paths["e\(i)"] as! String)
            docRef.getDocument { document, error in
                if let error = error{
                    print(error)
                }else{
                    if let document = document{
                        self.exercises.append(ExerciseInfo(name: document["name"] as! String, youtube: document["youtube"] as! String, difficulty: document["difficulty"] as! Int, docID: document.documentID))
                    }
                }
            }
        }
    }
}

// MARK: Table View Sender
    extension CurrentWorkoutVC: UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return exercises.count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTableCell", for: indexPath) as! ExerciseTableViewCell
            cell.nameLabel.text = exercises[indexPath.row].name
            cell.repCount.text = SetRepGeneration.generateReps()
            cell.setCount.text = SetRepGeneration.generateSets()
            
//            cell.youtubeLink.text = exercises[indexPath.row].youtube
            //        cell.playerView.load(withVideoId: "bsM1qdGAVbU") // Causing runtime error Maybe switch to a "More Details Page
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 250
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.performSegue(withIdentifier: "viewMoreDetails", sender: self)
            exerciseSelected = indexPath.row
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "viewMoreDetails"{
                let destinationVC = segue.destination as! MoreExeriseDetails
                destinationVC.exerciseName = exercises[exerciseSelected].name
            }
        }
        
        
    }
