//
//  HomeVC.swift
//  NAV
//
//  Created by Alex Chen on 2/9/23.
//

import Foundation
import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func viewWorkouts(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWorkouts", sender: self)

    }
    @IBAction func viewGoals(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToGoals", sender: self)
    }
    
    @IBAction func viewPreviousWorkouts(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToPreviousWorkouts", sender: self)
    }
    
}
