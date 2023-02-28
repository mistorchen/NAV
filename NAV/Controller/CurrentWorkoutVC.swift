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


class CurrentWorkoutVC: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var exerciseTable: UITableView!
    
    let database = FireStoreExerciseReader()
    
    var exercises: [ExerciseInfo] = [ExerciseInfo(name: "Pogo Hop", youtube: "www.youtube.com1")]
    
    override func viewDidLoad() {
        exerciseTable.dataSource = self
        super.viewDidLoad()
        exerciseTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func readDB(_ sender: UIButton) {
        getFieldParameters()
        exerciseTable.reloadData()
        
    }
    
    let db = Firestore.firestore()
    
    func getFieldParameters(){
        
        let docRef = db.document("\(dK.category.plyo.lower)/pogoHop")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDetails = document
                //                self.exerciseLabel.text = (dataDetails["Name"] as! String)
                
                self.exercises.append(ExerciseInfo(name: dataDetails["Name"] as! String, youtube: dataDetails["Youtube"] as! String))
            } else {
                print("Document does not exist")
            }
        }
    }
}

extension CurrentWorkoutVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTableCell", for: indexPath) as! ExerciseTableViewCell
        cell.nameLabel.text = exercises[indexPath.row].name
        cell.youtubeLink.text = exercises[indexPath.row].youtube
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
}
