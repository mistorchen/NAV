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
    
    

    var plyoSkillTree: [BasicExerciseInfo] = []
    var upperSkillTree: [BasicExerciseInfo] = []
    var lowerSkillTree: [BasicExerciseInfo] = []
    var coreSkillTree: [BasicExerciseInfo] = []
    
    var selectedTree: [BasicExerciseInfo] = []
    
    
    @IBOutlet weak var exerciseTable: UITableView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        
        
        
        exerciseTable.register(SkillTreeTableViewCell.nib(), forCellReuseIdentifier: SkillTreeTableViewCell.identifier)
        exerciseTable.delegate = self
        exerciseTable.dataSource = self
        readSkillTrees()
        setTree("lower")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.exerciseTable.reloadData()
        }
        super.viewDidLoad()
    }
    let db = Firestore.firestore()
    
    
    @IBAction func selectedSkillTree(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            setTree("lower")
            selectedTree = lowerSkillTree
            exerciseTable.reloadData()

        }else if sender.selectedSegmentIndex == 1{
            setTree("upper")
            selectedTree = upperSkillTree
            exerciseTable.reloadData()

        }else if sender.selectedSegmentIndex == 2{
            setTree("core")
            selectedTree = coreSkillTree
            exerciseTable.reloadData()

        }else if sender.selectedSegmentIndex == 3{
            setTree("plyo")
            selectedTree = plyoSkillTree
            exerciseTable.reloadData()
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
    func readSkillTrees(){
        readPlyoSkillTree()
        readCoreSkillTree()
        readLowerSkillTree()
        readUpperSkillTree()
    }
    
    
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
        return 100
    }
}

extension SkillTreeVC{
    func readPlyoSkillTree(){
        let docRef = db.collection(dK.skillTree.plyo).order(by: "level", descending: false)
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.plyoSkillTree.append(BasicExerciseInfo(name: document["name"] as! String, level: document["level"] as! Int))
                }
            }
        }
    }
    func readCoreSkillTree(){
        let docRef = db.collection(dK.skillTree.core).order(by: "level", descending: false)
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.coreSkillTree.append(BasicExerciseInfo(name: document["name"] as! String, level: document["level"] as! Int))
                }
            }
        }
    }
    func readLowerSkillTree(){
        let docRef = db.collection(dK.skillTree.lower).order(by: "level", descending: false)
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.lowerSkillTree.append(BasicExerciseInfo(name: document["name"] as! String, level: document["level"] as! Int))
                }
            }
        }
    }
    func readUpperSkillTree(){
        let docRef = db.collection(dK.skillTree.upper).order(by: "level", descending: false)
        docRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                for document in collection!.documents{
                    self.upperSkillTree.append(BasicExerciseInfo(name: document["name"] as! String, level: document["level"] as! Int))
                }
            }
        }
    }
}
