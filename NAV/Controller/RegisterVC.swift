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

    var username: String = ""
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFTS"{
            let destinationVC = segue.destination as! FirstTimeSetupVC
            destinationVC.username = username
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                }else{
                    self.username = self.emailTextField.text!
                    self.performSegue(withIdentifier: "goToFTS", sender: self)
                }
                    }
                }
            }
        }


