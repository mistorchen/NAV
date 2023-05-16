//
//  TextFieldTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 4/11/23.
//

import UIKit
import AVKit
import youtube_ios_player_helper
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class CurrentWorkoutTableViewCell: UITableViewCell , UITextFieldDelegate, YTPlayerViewDelegate{
    
    static let identifier = "CurrentWorkoutTableViewCell"
    
    static func nib() ->UINib{
        return UINib(nibName: CurrentWorkoutTableViewCell.identifier, bundle: nil)
    }
    
    var inventoryWritePath = ""
    var dayWritePath = ""
    var exerciseIndex = 0
    var programID = 0.0
    var difficulty = 0
    var programDay = 0
    
    let db = Firestore.firestore()

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var YTPlayer: YTPlayerView!
    @IBOutlet weak var setCount: UILabel!
    @IBOutlet weak var repCount: UILabel!
    @IBOutlet weak var set1Field: UITextField!
    @IBOutlet weak var set2Field: UITextField!
    @IBOutlet weak var set3Field: UITextField!

    
    override func awakeFromNib() {
//        set4.isHidden = true // Future edit for more sets
        super.awakeFromNib()
        // Initialization code
        set1Field.delegate = self
        set2Field.delegate = self
        set3Field.delegate = self
        
        
    }
    
    @IBAction func set1TextEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let weight = sender.text{
                writeSetWeight(1, Int(weight)!)
            }
        }
    }
    
    @IBAction func set2TextEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let weight = sender.text{
                writeSetWeight(2, Int(weight)!)
            }
        }
    }
    
    @IBAction func set3TextEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let weight = sender.text{
                writeSetWeight(3, Int(weight)!)
            }
        }
    }
    
    func writeSetWeight(_ set: Int, _ weight: Int){
        let currentRef = db.document(dayWritePath)
        currentRef.setData(["e\(exerciseIndex).\(set)" : weight], merge: true)
        let inventoryRef = db.document(inventoryWritePath)
        inventoryRef.setData(["1.\(programDay).\(set)" : weight] ,merge: true)
    }
    
    @IBAction func difficulty1(_ sender: UIButton) {
        writeDifficulty(1)
    }
    @IBAction func difficulty2(_ sender: UIButton) {
        writeDifficulty(2)
    }
    @IBAction func difficulty3(_ sender: UIButton) {
        writeDifficulty(3)
    }
    
    func writeDifficulty(_ difficulty: Int){
        let docRef = db.collection(dayWritePath).document(inventoryWritePath)
        docRef.setData(["difficulty" : difficulty], merge: true)
    }
    
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("\(textField.text ?? "")")
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
