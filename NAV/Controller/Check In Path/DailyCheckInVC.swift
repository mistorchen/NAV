//
//  dailyCheckIn.swift
//  NAV
//
//  Created by Alex Chen on 6/12/23.
//

import Foundation
import UIKit

class DailyCheckInVC: UIViewController{
    
    @IBOutlet weak var belowFeel: UIButton!
    @IBOutlet weak var goodFeel: UIButton!
    @IBOutlet weak var averageFeel: UIButton!
    
    @IBOutlet weak var belowSleep: UIButton!
    @IBOutlet weak var averageSleep: UIButton!
    @IBOutlet weak var goodSleep: UIButton!
    
    
    @IBOutlet weak var easyWorkout: UIButton!
    @IBOutlet weak var averageWorkout: UIButton!
    @IBOutlet weak var hardWorkout: UIButton!


    
    override func viewDidLoad() {
        configureButtons()
        
        
        
        super.viewDidLoad()
    }
    
    
    
}
// MARK: Configure Buttons
extension DailyCheckInVC{
    func configureButtons(){
        configureButtonAppearance(belowFeel)
        configureButtonAppearance(averageFeel)
        configureButtonAppearance(goodFeel)
        
        configureButtonAppearance(belowSleep)
        configureButtonAppearance(averageSleep)
        configureButtonAppearance(goodSleep)
        
        configureButtonAppearance(easyWorkout)
        configureButtonAppearance(averageWorkout)
        configureButtonAppearance(hardWorkout)


    }
    func configureButtonAppearance(_ sender: UIButton){
        sender.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
        sender.layer.cornerRadius = 5
        
    }
}

