//
//  ExerciseTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 3/2/23.
//

import UIKit

class PreviewExerciseTableViewCell: UITableViewCell{

    static let identifier = "PreviewExerciseTableViewCell"
    
    static func nib() ->UINib{
        return UINib(nibName: PreviewExerciseTableViewCell.identifier, bundle: nil)
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var playerView: YTPlayerView!
    
    @IBOutlet weak var setCount: UILabel!
    @IBOutlet weak var repCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    
    
    
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//
}
