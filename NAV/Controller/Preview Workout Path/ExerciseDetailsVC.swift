//
//  MoreExerciseDetails.swift
//  NAV
//
//  Created by Alex Chen on 3/9/23.
//

import Foundation
import UIKit
import Charts
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore



class ExerciseDetailsVC: UIViewController{
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    let db = Firestore.firestore()
    var exerciseName = ""
    var exerciseID = ""
    
    
    
    override func viewDidLoad(){
        
        detailsTableView.register(ExerciseDetailsTableViewCell
            .nib(), forCellReuseIdentifier: ExerciseDetailsTableViewCell.identifier)
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        
        super.viewDidLoad()
        
        
    }
    
    

}

extension ExerciseDetailsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseDetailsTableViewCell.identifier, for: indexPath) as! ExerciseDetailsTableViewCell
        cell.exerciseNameLabel.text = exerciseName
        cell.YTPlayer.load(withVideoId: "gEZbarOeI3o")
        cell.getWeights(exerciseID)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailsTableView.deselectRow(at: indexPath, animated: true)
    }
    

}
