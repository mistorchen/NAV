//
//  ViewController.swift
//  NAV
//
//  Created by Alex Chen on 2/7/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                if let _ = user {
                    self.performSegue(withIdentifier: "loggedIn", sender: self)
                }
            }
        }
    }
    
}

