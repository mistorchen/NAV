//
//  SkillTreeTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 5/22/23.
//

import UIKit

class SkillTreeTableViewCell: UITableViewCell {
    
    static let identifier = "SkillTreeTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    static func nib() ->UINib{
        return UINib(nibName: SkillTreeTableViewCell.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
