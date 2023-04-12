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
    
    @IBOutlet weak var exerciseTable: UITableView!
    
    
    
    override func viewDidLoad() {
        exerciseTable.reloadData()
        exerciseTable.register(CurrentWorkoutTableViewCell.nib(), forCellReuseIdentifier: CurrentWorkoutTableViewCell.identifier)
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        
        
        super.viewDidLoad()
    }
    
    
    @IBAction func testRead(_ sender: UIButton) {
        getWorkout()
        
        
        for temp in exercises{
            print(temp.order)
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
                        self.exercises.append(ExerciseInfo(name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int))
                    
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





extension CurrentWorkoutVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentWorkoutTableViewCell.identifier, for: indexPath) as! CurrentWorkoutTableViewCell
        cell.exerciseName.text = "TEST NAME"
        cell.repCount.text = "TEST REPS"
        cell.setCount.text = "TEST SETS"
        cell.YTPlayer.delegate = self
        cell.YTPlayer.load(withVideoId: "PLSfjBMBIu8")
        
        
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
