//
//  ExerciseTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 3/2/23.
//

import UIKit
import youtube_ios_player_helper

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var youtubeLink: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//
}
