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
        setTree("lower")
        super.viewDidLoad()
        
    }
    let db = Firestore.firestore()
    
    
    @IBAction func selectedSkillTree(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            setTree("lower")
        }else if sender.selectedSegmentIndex == 1{
            setTree("upper")
        }else if sender.selectedSegmentIndex == 2{
            setTree("core")
        }else if sender.selectedSegmentIndex == 3{
            setTree("plyo")
        }
    }
    func setTree(_ selectedTree: String){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document(selectedTree)
        
        docRef.getDocument { querySnapshot, err in
            if let err = err{
                print(err)
            }else{
                if let document = querySnapshot{
                    self.label.text = String(document["exp"] as! Int)
                }
            }
        }
        
    }
    
    
}
