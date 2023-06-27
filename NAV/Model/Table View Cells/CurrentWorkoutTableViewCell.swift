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
    var currentWorkoutPath = ""
    var exerciseIndex = 0
    var programID = 0
    var difficulty = 0
    var programDay = 0
    
    
    var set1Weight = 0
    var set2Weight = 0
    var set3Weight = 0
    
    let db = Firestore.firestore()

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var YTPlayer: YTPlayerView!
    @IBOutlet weak var setCount: UILabel!
    @IBOutlet weak var repCount: UILabel!
    @IBOutlet weak var set1Field: UITextField!
    @IBOutlet weak var set2Field: UITextField!
    @IBOutlet weak var set3Field: UITextField!
 
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    
    override func awakeFromNib() {
//        set4.isHidden = true // Future edit for more sets
        // Initialization code
        checkButtonStatus()
        configureButtons()
        set1Field.delegate = self
        set2Field.delegate = self
        set3Field.delegate = self
        
        super.awakeFromNib()

        
    }
    
    @IBAction func set1TextEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let weight = sender.text{
                writeSetWeight(1, Int(weight)!)
            }
        }
        checkButtonStatus()

    }
    
    @IBAction func set2TextEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let weight = sender.text{
                writeSetWeight(2, Int(weight)!)
            }
        }
        checkButtonStatus()

    }
    
    @IBAction func set3TextEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let weight = sender.text{
                writeSetWeight(3, Int(weight)!)
            }
        }
        checkButtonStatus()
    }
    
    func writeSetWeight(_ set: Int, _ weight: Int){
        let currentRef = db.document(currentWorkoutPath)
        currentRef.setData(["e\(exerciseIndex)s\(set)" : weight], merge: true)
        let inventoryRef = db.document(inventoryWritePath)
        inventoryRef.setData(["\(programID).\(programDay).\(set)" : weight] ,merge: true)
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
        let currentRef = db.document(currentWorkoutPath)
        currentRef.setData(["e\(exerciseIndex)d" : difficulty], merge: true)
    }
    
    func resetButtons(){
        easyButton.isEnabled = false
        mediumButton.isEnabled = false
        hardButton.isEnabled = false

        easyButton.backgroundColor = .gray
        mediumButton.backgroundColor = .gray
        hardButton.backgroundColor = .gray
        
    }
    func resetTextFields(){
        set1Field.text = ""
        set2Field.text = ""
        set3Field.text = ""
    }
    
    func checkButtonStatus(){
        if set1Field.text != "" && set2Field.text != "" && set3Field.text != ""{
            easyButton.isEnabled = true
            mediumButton.isEnabled = true
            hardButton.isEnabled = true
            
            easyButton.backgroundColor = K.color.beige
            mediumButton.backgroundColor = K.color.beige
            hardButton.backgroundColor = K.color.beige
        }
    }
    
    func configureButtons(){
        easyButton.layer.cornerRadius = 10
        mediumButton.layer.cornerRadius = 10
        hardButton.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
}
