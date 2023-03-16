//
//  SkillTreeVC.swift
//  NAV
//
//  Created by Alex Chen on 3/16/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SkillTreeVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = auth
        
    }
    var auth = Auth.auth().currentUser?.uid
    
    
}
