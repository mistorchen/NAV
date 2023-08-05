//
//  CWExerciseTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 8/3/23.
//

import UIKit

class CWExerciseTableViewCell: UITableViewCell {
    static let identifier = "CWExerciseTableViewCell"
        
    static func nib() ->UINib{
        return UINib(nibName: CWExerciseTableViewCell.identifier, bundle: nil)
    }
    
    var selectedProgram: [ProgramExerciseInfo]?
    
    @IBOutlet weak var exerciseName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
