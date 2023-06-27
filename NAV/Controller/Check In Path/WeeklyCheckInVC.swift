//
//  weeklyCheckIn.swift
//  NAV
//
//  Created by Alex Chen on 6/12/23.
//

import Foundation
import UIKit

class WeeklyCheckInVC:UIViewController{
    @IBOutlet weak var belowFeel: UIButton!
    @IBOutlet weak var averageFeel: UIButton!
    @IBOutlet weak var goodFeel: UIButton!
    
    @IBOutlet weak var belowSleep: UIButton!
    @IBOutlet weak var averageSleep: UIButton!
    @IBOutlet weak var goodSleep: UIButton!
    
    @IBOutlet weak var yesSleep: UIButton!
    @IBOutlet weak var noSleep: UIButton!
    
    @IBOutlet weak var easyWorkout: UIButton!
    @IBOutlet weak var averageWorkout: UIButton!
    @IBOutlet weak var hardWorkout: UIButton!
    
    @IBOutlet weak var yesProgramChange: UIButton!
    @IBOutlet weak var noProgramChange: UIButton!
    
}
// MARK: Configure Buttons
extension WeeklyCheckInVC{
    func configureButtons(){
        configureButtonAppearance(belowFeel)
        configureButtonAppearance(averageFeel)
        configureButtonAppearance(goodFeel)
        
        configureButtonAppearance(belowSleep)
        configureButtonAppearance(averageSleep)
        configureButtonAppearance(goodSleep)
        
        configureButtonAppearance(yesSleep)
        configureButtonAppearance(noSleep)
        
        configureButtonAppearance(easyWorkout)
        configureButtonAppearance(averageWorkout)
        configureButtonAppearance(hardWorkout)
        
        configureButtonAppearance(yesProgramChange)
        configureButtonAppearance(noProgramChange)


    }
    func configureButtonAppearance(_ sender: UIButton){
        sender.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
        sender.layer.cornerRadius = 5
        
    }
}
