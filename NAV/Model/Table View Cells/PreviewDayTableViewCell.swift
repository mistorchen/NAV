//
//  PreviewDayTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 8/2/23.
//

import UIKit

class PreviewDayTableViewCell: UITableViewCell {
    static let identifier = "PreviewDayTableViewCell"
    
    @IBOutlet weak var dayTitleLabel: UILabel!
    
    static func nib() ->UINib{
        return UINib(nibName: PreviewDayTableViewCell.identifier, bundle: nil)
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
