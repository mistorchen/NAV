//
//  WorkoutVC.swift
//  NAV
//
//  Created by Alex Chen on 2/9/23.
//

import Foundation
import UIKit

class CurrentWorkoutVC: UIViewController {

    
    @IBOutlet weak var exerciseLabel: UILabel!
    
    let database = FireStoreExerciseReader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func readDB(_ sender: UIButton) {
        database.getExercises()
    }
    
}
