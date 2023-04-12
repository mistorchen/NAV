//
//  TextFieldTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 4/11/23.
//

import UIKit
import AVKit
import youtube_ios_player_helper

class CurrentWorkoutTableViewCell: UITableViewCell , UITextFieldDelegate, YTPlayerViewDelegate{
    
    static let identifier = "CurrentWorkoutTableViewCell"
    
    static func nib() ->UINib{
        return UINib(nibName: CurrentWorkoutTableViewCell.identifier, bundle: nil)
    }

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var YTPlayer: YTPlayerView!
    @IBOutlet weak var setCount: UILabel!
    @IBOutlet weak var repCount: UILabel!
    @IBOutlet weak var set1Field: UITextField!
    @IBOutlet weak var set2Field: UITextField!
    @IBOutlet weak var set3Field: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        set1Field.delegate = self
        set2Field.delegate = self
        set3Field.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("\(textField.text ?? "")")
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
