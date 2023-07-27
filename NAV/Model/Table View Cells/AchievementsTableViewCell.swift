//
//  AchievementsTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 6/28/23.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {

    static let identifier = "AchievementsTableViewCell"
    
    static func nib() ->UINib{
        return UINib(nibName: AchievementsTableViewCell.identifier, bundle: nil)
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
