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


class HomeVC: UIViewController , FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource{

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var editLoadout: UIButton!
    @IBOutlet weak var newProgram: UIButton!
    @IBOutlet weak var badgesButton: UIButton!
    @IBOutlet weak var startWorkout: UIButton!
    
    let formatter = DateFormatter()
    var streakDates: [String] = []
    var scheduleDates: [String] = []
    
    override func viewDidLoad() {
        newProgram.isEnabled = false
        newProgram.isHidden = true
        calendar.delegate = self
        calendar.dataSource = self
        configureCalendar()
        configureMenuButtons()
        self.title = "Home"
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            
            self.programMakerAccess()
            self.calendar.reloadData()

        }
        super.viewDidLoad()
    }
    
}


// MARK: Calendar Functions
extension HomeVC{
    func configureCalendar(){
        calendar.allowsSelection = false
        let gestureRec = UITapGestureRecognizer(target: self, action:  #selector (self.performSegue (_:)))
        calendar.addGestureRecognizer(gestureRec)
        
    }
    @objc func performSegue(_ sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "goToCalendar", sender: self)
        
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let tabBar = tabBarController as! TabBarViewController
        streakDates = tabBar.streakDates

        
        formatter.dateFormat = "MM-dd-yyyy"
        let streakDay = formatter.string(from: date)
        
        if streakDates.contains(streakDay){
            return .green
        }
        return nil
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let tabBar = tabBarController as! TabBarViewController
        scheduleDates = tabBar.scheduleDates
        
        formatter.dateFormat = "MM-dd-yyyy"
        let scheduleDate = formatter.string(from: date)
        
        if scheduleDates.contains(scheduleDate){
            return 1
        }
        return 0
    }
    
}

// MARK:  Menu Buttons
extension HomeVC{
    func configureMenuButtons(){
        editLoadout.titleLabel!.textAlignment = .center
        editLoadout.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 13.0)
        editLoadout.titleLabel!.adjustsFontSizeToFitWidth = true
        editLoadout.layer.cornerRadius = 15
        
        checkInButton.titleLabel!.textAlignment = .center
        checkInButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 13.0)
        checkInButton.titleLabel!.adjustsFontSizeToFitWidth = true
        checkInButton.layer.cornerRadius = 15
        
        badgesButton.titleLabel!.textAlignment = .center
        badgesButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 13.0)
        badgesButton.titleLabel!.adjustsFontSizeToFitWidth = true
        badgesButton.layer.cornerRadius = 15
        
        startWorkout.layer.cornerRadius = 15
        newProgram.layer.cornerRadius = 15

        
    }
    func programMakerAccess(){
        let tabBar = tabBarController as! TabBarViewController
        if tabBar.newProgram == true{
            newProgram.isEnabled = true
            newProgram.isHidden = false
        }
    }
    
    @IBAction func editLoadout(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToLoadout", sender: self)
    }
    @IBAction func viewAccount(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAccount", sender: self)
    }
    @IBAction func goToCurrentWorkout(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCurrentWorkout", sender: self)
    }
    @IBAction func goToCheckIn(_ sender: UIButton) {
        if Date().dayNumberOfWeek == 1{
            self.performSegue(withIdentifier: "goToWeeklyCheckIn", sender: self)

        }else{
            self.performSegue(withIdentifier: "goToDailyCheckIn", sender: self)
        }
    }
    @IBAction func goToProgramMaker(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToProgramMaker", sender: self)

    }
}
