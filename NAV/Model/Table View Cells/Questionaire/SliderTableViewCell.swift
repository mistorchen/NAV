//
//  SliderTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 6/14/23.
//

import UIKit

class SliderTableViewCell: UITableViewCell {

    static let identifier = "SliderTableViewCell"
    
    static func nib() ->UINib{
        return UINib(nibName: SliderTableViewCell.identifier, bundle: nil)
    }
    
    @IBOutlet weak var slider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
