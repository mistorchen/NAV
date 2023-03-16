//
//  AcountVC.swift
//  NAV
//
//  Created by Alex Chen on 3/16/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class AccountVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutTapped(_ sender: UIButton) {
        logout()
        self.performSegue(withIdentifier: "loggedOut", sender: self)
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
