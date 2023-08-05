//
//  CWSetRepTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 8/3/23.
//

import UIKit

class CWSingleSetTableViewCell: UITableViewCell {
    static let identifier = "CWSingleSetTableViewCell"
    
    static func nib() ->UINib{
        return UINib(nibName: CWSingleSetTableViewCell.identifier, bundle: nil)
    }
    
    var selectedProgram = [ProgramExerciseInfo]()
    var currentWorkoutPath = String()
    var inventoryPath = String()
    var setDone = false
    
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var setsLabel: UILabel!
    
    override func awakeFromNib() {
        configureButton()
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        weightTextField.text = ""
        super.prepareForReuse()
    }
    func configureButton(){
        weightTextField.text = ""
        weightTextField.attributedPlaceholder = NSAttributedString(
            string: "-",
            attributes: [NSAttributedString.Key.foregroundColor: K.color.winter]
        )
    }
    @IBAction func setDone(_ sender: UIButton) {
        setDone = !setDone
        
        if setDone == false{
            if let image = UIImage(systemName: "checkmark.square"){
                sender.setImage(image, for: .normal)
            }
        }else{
            if let image = UIImage(systemName: "checkmark.square.fill"){
                sender.setImage(image, for: .normal)
            }
        }
    }
}
