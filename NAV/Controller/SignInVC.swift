//
//  SignInVC.swift
//  NAV
//
//  Created by Alex Chen on 2/11/23.
//

import Foundation
import UIKit


class SignInVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func viewRegister(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    @IBAction func viewLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToLogin", sender: self)

    }
    
}
