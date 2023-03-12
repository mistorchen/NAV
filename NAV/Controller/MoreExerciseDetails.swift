//
//  MoreExerciseDetails.swift
//  NAV
//
//  Created by Alex Chen on 3/9/23.
//

import Foundation
import UIKit


class MoreExeriseDetails: UIViewController{
    
    
    @IBOutlet weak var exerciseTitle: UILabel!
    
    var exerciseName = ""
    
    override func viewDidLoad(){
        exerciseTitle.text = exerciseName
        super.viewDidLoad()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        exerciseTitle.text = exerciseName
    }
}
