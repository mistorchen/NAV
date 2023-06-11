//
//  FinishedWorkoutVC.swift
//  NAV
//
//  Created by Alex Chen on 5/16/23.
//

import Foundation
import UIKit

class GeneratingVC: UIViewController{

    
    override func viewDidLoad() {

        self.navigationItem.setHidesBackButton(true, animated: true)
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
}

