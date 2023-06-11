//
//  MenuButtonCollectionViewCell.swift
//  NAV
//
//  Created by Alex Chen on 6/6/23.
//

import UIKit

class MenuButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var button: UIButton!
    
    static let identifier = "MenuButtonCollectionViewCell"

    static func nib() ->UINib{
        return UINib(nibName: MenuButtonCollectionViewCell.identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        print("a")
    }
}
