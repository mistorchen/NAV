//
//  HomeVC.swift
//  NAV
//
//  Created by Alex Chen on 2/9/23.
//

import Foundation
import UIKit
import FSCalendar
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


class HomeVC: UIViewController , FSCalendarDelegate{
    

    
    
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        
    }
    
}


// MARK: Calendar Functions
extension HomeVC{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        let string = formatter.string(from: date)
        print("\(string)")
        let newString = formatter.string(from: date-1)
        print("\(newString)")
    }
}
// MARK: Buttons

extension HomeVC{
    @IBAction func editLoadout(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToLoadout", sender: self)
    }
    @IBAction func viewAccount(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAccount", sender: self)
    }
    @IBAction func goToCurrentWorkout(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCurrentWorkout", sender: self)
    }
    @IBAction func goToProgramMaker(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToProgramMaker", sender: self)
    }
    @IBAction func goToCheckIn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCheckIn", sender: self)

    }
}

