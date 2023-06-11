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

class SkillTreeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

   
    
    var selectedTree: [BasicExerciseInfo] = []
    
    
    @IBOutlet weak var exerciseTable: UITableView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        let tabBar = tabBarController as! TabBarViewController
        selectedTree = tabBar.lowerSkillTree
        
        exerciseTable.register(SkillTreeTableViewCell.nib(), forCellReuseIdentifier: SkillTreeTableViewCell.identifier)
        exerciseTable.delegate = self
        exerciseTable.dataSource = self
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.exerciseTable.reloadData()
        }
        super.viewDidLoad()
    }
    let db = Firestore.firestore()
    
    
    @IBAction func selectedSkillTree(_ sender: UISegmentedControl) {
        let tabBar = tabBarController as! TabBarViewController
        if sender.selectedSegmentIndex == 0{
            selectedTree = tabBar.lowerSkillTree
            exerciseTable.reloadData()

        }else if sender.selectedSegmentIndex == 1{
            selectedTree = tabBar.upperSkillTree
            exerciseTable.reloadData()

        }else if sender.selectedSegmentIndex == 2{
            selectedTree = tabBar.coreSkillTree
            exerciseTable.reloadData()

        }else if sender.selectedSegmentIndex == 3{
            selectedTree = tabBar.plyoSkillTree
            exerciseTable.reloadData()
        }
    }
//    func setTree(_ selectedTree: String){
//        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("skillTree").document(selectedTree)
//
//        docRef.getDocument { querySnapshot, err in
//            if let err = err{
//                print(err)
//            }else{
//                if let document = querySnapshot{
//                    self.label.text = String(document["exp"] as! Int)
//                }
//            }
//        }
//
//    }
    
    
    
}

extension SkillTreeVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTree.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SkillTreeTableViewCell.identifier, for: indexPath) as! SkillTreeTableViewCell

        cell.levelLabel.text = "\(selectedTree[indexPath.row].level)"
        cell.nameLabel.text = selectedTree[indexPath.row].name
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


