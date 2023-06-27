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
        showApp()
    }

    
    
    
    
    func logout(){
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func showApp(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var  viewController: UIViewController
        viewController = storyboard.instantiateViewController(withIdentifier: "Main")
        self.present(viewController, animated: true, completion: nil)
    }
}
