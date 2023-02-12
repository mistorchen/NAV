//
//  RegisterVC.swift
//  NAV
//
//  Created by Alex Chen on 2/11/23.
//

import Foundation
import UIKit
import FirebaseAuth

class RegisterVC: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                }else{
                    self.performSegue(withIdentifier: "goToFirstTimeSetup", sender: self)
                }
                    }
                }
            }
        }

