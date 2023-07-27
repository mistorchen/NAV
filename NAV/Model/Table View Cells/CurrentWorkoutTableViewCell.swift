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
    var reps = 0
    var weightLifted = [0,0,0]
    var week = 0
    
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
                weightLifted[0] = Int(weight)!
            }
        }
        writeVolume()
        checkButtonStatus()
        
    }
    
    @IBAction func set2TextEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let weight = sender.text{
                writeSetWeight(2, Int(weight)!)
                weightLifted[1] = Int(weight)!
                
            }
        }
        writeVolume()
        checkButtonStatus()
        
    }
    
    @IBAction func set3TextEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let weight = sender.text{
                writeSetWeight(3, Int(weight)!)
                weightLifted[2] = Int(weight)!
            }
        }
        writeVolume()
        checkButtonStatus()
    }
    
    func writeSetWeight(_ set: Int, _ weight: Int){
        let currentRef = db.document(currentWorkoutPath)
        currentRef.setData(["e\(exerciseIndex)s\(set)" : weight], merge: true)
        //        let inventoryRef = db.document(inventoryWritePath)
        //        inventoryRef.setData(["\(programID).\(programDay).\(set)" : weight] ,merge: true)
    }
    
    @IBAction func difficulty1(_ sender: UIButton) {
        writeDifficulty(1)
        buttonSelected(1)
    }
    @IBAction func difficulty2(_ sender: UIButton) {
        writeDifficulty(2)
        buttonSelected(2)
    }
    @IBAction func difficulty3(_ sender: UIButton) {
        writeDifficulty(3)
        buttonSelected(3)
    }
    
    func writeVolume(){
        if set1Field.text?.isEmpty == false && set2Field.text?.isEmpty == false && set3Field.text?.isEmpty == false {
            
            var volume = 0
            for count in 0 ... weightLifted.count - 1{
                volume = volume + weightLifted[count] * reps
            }
            
            
            let inventoryRef = db.document(inventoryWritePath)
            inventoryRef.getDocument { document, error in
                if let error = error{
                    print(error)
                }else{
                    if let document = document{
                        if let data = document["p\(self.programID)Volume"]{
                            var volumeArray = data as! [Int]
                            if volumeArray.count - 1 < self.week{
                                volumeArray.append(volume)
                            }else{
                                volumeArray[self.week] = volume
                            }
                            
                            
                            inventoryRef.setData(["p\(self.programID)Volume" : volumeArray], merge: true)
                        }else{
                            inventoryRef.setData(["p\(self.programID)Volume" : [volume]], merge: true)
                        }
                        
                        if let data = document["programs"]{
                            var programs = data as! [Int]
                            if programs.contains(self.programID){
                            }else{
                                programs.append(self.programID)
                            }
                            inventoryRef.setData(["programs" : programs], merge: true)
                        }else{
                            inventoryRef.setData(["programs" : [self.programID]], merge: true)
                        }
                    }
                }
            }
        }
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
    func buttonSelected(_ difficulty: Int){
        switch difficulty{
        case 1:
            easyButton.backgroundColor = K.color.beige
            mediumButton.backgroundColor = .gray
            hardButton.backgroundColor = .gray
        case 2:
            easyButton.backgroundColor = .gray
            mediumButton.backgroundColor = K.color.beige
            hardButton.backgroundColor = .gray
        case 3:
            easyButton.backgroundColor = .gray
            mediumButton.backgroundColor = .gray
            hardButton.backgroundColor = K.color.beige
        default:
            easyButton.backgroundColor = K.color.beige
            mediumButton.backgroundColor = K.color.beige
            hardButton.backgroundColor = K.color.beige
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
}
