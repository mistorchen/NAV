//
//  CWDifficultyTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 8/3/23.
//

import UIKit

class CWDifficultyTableViewCell: UITableViewCell {
    static let identifier = "CWDifficultyTableViewCell"
        
    static func nib() ->UINib{
        return UINib(nibName: CWDifficultyTableViewCell.identifier, bundle: nil)
    }
    
    @IBOutlet weak var difficulty1: UIButton!
    @IBOutlet weak var difficulty2: UIButton!
    @IBOutlet weak var difficulty3: UIButton!
    @IBOutlet weak var difficulty4: UIButton!
    @IBOutlet weak var difficulty5: UIButton!
    
    
    var selectedProgram = [ProgramExerciseInfo]()
    var currentWorkoutPath = String()
    var inventoryPath = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func Pressed1(_ sender: UIButton) {
        buttonPressed(1)
        print(currentWorkoutPath)
    }
    @IBAction func Pressed2(_ sender: UIButton) {
        buttonPressed(2)
    }
    @IBAction func Pressed3(_ sender: UIButton) {
        buttonPressed(3)
    }
    @IBAction func Pressed4(_ sender: UIButton) {
        buttonPressed(4)
    }
    @IBAction func Pressed5(_ sender: UIButton) {
        buttonPressed(5)
    }
    
    func buttonPressed(_ button: Int){
        difficulty1.backgroundColor = .lightGray
        difficulty2.backgroundColor = .lightGray
        difficulty3.backgroundColor = .lightGray
        difficulty4.backgroundColor = .lightGray
        difficulty5.backgroundColor = .lightGray

        switch button{
        case 1:
            difficulty1.backgroundColor = K.color.winter
        case 2:
            difficulty2.backgroundColor = K.color.winter
        case 3:
            difficulty3.backgroundColor = K.color.winter
        case 4:
            difficulty4.backgroundColor = K.color.winter
        case 5:
            difficulty5.backgroundColor = K.color.winter
        default:
            print("difficulty error")
        }
        
    }
    
}
