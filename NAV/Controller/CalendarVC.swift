//
//  CalendarVC.swift
//  NAV
//
//  Created by Alex Chen on 6/7/23.
//

import Foundation
import UIKit
import FSCalendar
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class CalendarVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    @IBOutlet weak var calendar: FSCalendar!

    var streakDates: [String] = []

    let formatter = DateFormatter()
    let db = Firestore.firestore()

    override func viewDidLoad() {

        calendar.delegate = self
        calendar.dataSource = self
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.calendar.reloadData()

        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "MM-dd-yyyy"
        let selectedDay = formatter.string(from: date)
        print(selectedDay)
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
    
    
    
    
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//        formatter.dateFormat = "MM-dd-yyyy"
//        let streakDay = formatter.string(from: date)
//        print(streakDay)
//        if streakDay == selectedDate{
//            return .systemPink
//        }
//        return nil
//    }

}
