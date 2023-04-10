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
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                }else{
                    self.username = username
                    self.performSegue(withIdentifier: "goToBasicInfoSetupVC", sender: self)
                }
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBasicInfoSetupVC"{
            let destinationVC = segue.destination as! FirstTimeSetupVC
            destinationVC.username = username
        }
    }
}


