//
//  FirstTimeSetupVC.swift
//  NAV
//
//  Created by Alex Chen on 2/9/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirstTimeSetupVC: UIViewController {
    
    var username = ""
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        db.collection("users").document("\(Auth.auth().currentUser!.uid)").setData(["username" : username])
    }
    
    
    
}
