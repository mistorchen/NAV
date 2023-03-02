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
    var exercises: [ExerciseInfo] = []
    
    override func viewDidLoad() {
        exerciseTable.register(UINib(nibName: "ExerciseTableViewCell", bundle: nil), forCellReuseIdentifier: "ExerciseTableCell")
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        super.viewDidLoad()
        exerciseTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func readDB(_ sender: UIButton) {
        
        getCollectionDocs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.exerciseTable.reloadData()
        }
        
    }
    
    let db = Firestore.firestore()
    
    func getCollectionDocs(){
        exercises = []
//        Get a collection and data
        let docRef = db.collection("\(dK.category.plyo.lower)")

        docRef.getDocuments { (collection, error) in
            if let error = error{
                print(error)
            }else {
                for document in collection!.documents{
                    self.exercises.append(ExerciseInfo(name: document["Name"] as! String, youtube: document["Youtube"] as! String, difficulty: document["difficulty"] as! Int))
                }
            }
        }
        
        
        
        
//        let docRef = db.document("\(dK.category.plyo.lower)/pogoHop")
//        docRef.getDocuments { (document, error) in
//            if let document = document {
//                let dataDetails = document
//                print(dataDetails)
//                self.exercises.append(ExerciseInfo(name: dataDetails["Name"] as! String, youtube: dataDetails["Youtube"] as! String))
//            } else {
//                print("Document does not exist")
//            }
//        }
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
//        cell.playerView.load(withVideoId: "bsM1qdGAVbU") // Causing runtime error Maybe switch to a "More Details Page
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
}
