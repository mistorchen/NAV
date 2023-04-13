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
    
    var exerciseWritePath = ""
    var dayWritePath = ""
    var difficulty = 0
    
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
                writeSetWeight(set: "set1weight", weight: Int(weight)!)
            }
        }
    }
    
    @IBAction func set2TextEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let weight = sender.text{
                writeSetWeight(set: "set2weight", weight: Int(weight)!)
            }
        }
    }
    
    @IBAction func set3TextEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let weight = sender.text{
                writeSetWeight(set: "set3weight", weight: Int(weight)!)
            }
        }
    }
    
    func writeSetWeight(set: String, weight: Int){
        let docRef = db.collection(dayWritePath).document(exerciseWritePath)
        docRef.setData([set : weight], merge: true)
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
    @IBAction func difficulty4(_ sender: UIButton) {
        writeDifficulty(4)
    }
    @IBAction func difficulty5(_ sender: UIButton) {
        writeDifficulty(5)
    }
    @IBAction func difficulty6(_ sender: UIButton) {
        writeDifficulty(6)
    }
    @IBAction func difficulty7(_ sender: UIButton) {
        writeDifficulty(7)
    }
    
    func writeDifficulty(_ difficulty: Int){
        let docRef = db.collection(dayWritePath).document(exerciseWritePath)
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
