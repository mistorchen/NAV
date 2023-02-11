//
//  ViewController.swift
//  NAV
//
//  Created by Alex Chen on 2/7/23.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func viewFTS(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToFirstTimeSetup", sender: self)
    }
    
}

