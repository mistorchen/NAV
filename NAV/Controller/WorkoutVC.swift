//
//  WorkoutVC.swift
//  NAV
//
//  Created by Alex Chen on 2/9/23.
//

import Foundation
import UIKit

class WorkoutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func viewCurrentWorkout(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCurrentWorkout", sender: self)
    }
}
