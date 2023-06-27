//
//  TableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 6/14/23.
//

import UIKit

class PolarAnswerTableViewCell: UITableViewCell {
    static let identifier = "PolarAnswerTableViewCell"
    
    static func nib() ->UINib{
        return UINib(nibName: PolarAnswerTableViewCell.identifier, bundle: nil)
    }
    
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func yesButton(_ sender: UIButton!) {
    }
    @IBAction func noButton(_ sender: UIButton!) {
    }
    
}
