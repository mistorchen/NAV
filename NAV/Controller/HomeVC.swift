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
    @IBAction func viewAccount(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAccount", sender: self)
    }
    @IBAction func goToCurrentWorkout(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCurrentWorkout", sender: self)
    }
    @IBAction func goToProgramMaker(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToProgramMaker", sender: self)
    }
}

