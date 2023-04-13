//
//  FinishedWorkoutVC.swift
//  NAV
//
//  Created by Alex Chen on 4/12/23.
//

import Foundation
import UIKit

class FinishedWorkoutVC: UIViewController {

    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.performSegue(withIdentifier: "goToHomeVC", sender: self)
            
        }
        
    }
}
