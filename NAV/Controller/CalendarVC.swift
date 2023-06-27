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
    @IBOutlet weak var daysRemaining: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var calendar: FSCalendar!
    
    var streakDates: [String] = []
    
    let formatter = DateFormatter()
    let db = Firestore.firestore()
    
    var calendarStart: String = ""
    var calendarEnd: String = ""
    var totalDays = 0
    
    var newWorkoutDates: [String] = []
    var scheduleDates: [String] = []
    
    
    override func viewDidLoad() {
        
        
        formatter.dateFormat = "MM-dd-yyyy"
        calendarStart = formatter.string(from: Date().startOfMonthDate)
        calendarEnd = formatter.string(from: Date().endOfMonthDate)
        
        calendar.allowsSelection = false
        
        
        let tabBar = tabBarController as! TabBarViewController
        totalDays = tabBar.totalDays
        if totalDays == 0{
            doneButton.isEnabled = true
        }else{
            doneButton.isEnabled = false
        }
        
        
        calendar.delegate = self
        calendar.dataSource = self
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.calendar.reloadData()
        }
    }
    @IBAction func donePressed(_ sender: UIButton) {
        
        
        calendar.allowsSelection = false
        scheduleDates = scheduleDates + newWorkoutDates
        writeCalendarDates(scheduleDates)
        formatter.dateFormat = "MM-dd-yyyy"
        calendarStart = formatter.string(from: Date().startOfMonthDate)
        calendarEnd = formatter.string(from: Date().endOfMonthDate)
        
        
        doneButton.isEnabled = false
        
        calendar.reloadData()
    }
    @IBAction func rescheduleCurrentWeek(_ sender: UIButton) {
        calendar.allowsMultipleSelection = true
        calendar.allowsSelection = true

        let tabBar = tabBarController as! TabBarViewController
        totalDays = tabBar.totalDays - tabBar.currentDay + 1
        daysRemaining.text = "Days Remaining: \(totalDays)"

        
        
        calendar.allowsSelection = true
        newWorkoutDates.removeAll()
        formatter.dateFormat = "MM-dd-yyyy"
        calendarStart = formatter.string(from: Date().today)
        calendarEnd = formatter.string(from: Date().endOfWeekDate)
        
        let datesInWeek = Date().dateToString(Date().datesInWeek())
        scheduleDates = scheduleDates.filter( { datesInWeek.contains($0) })
        
        
        
        calendar.reloadData()
    }
    @IBAction func scheduleNext(_ sender: UIButton) {
        calendar.allowsSelection = true
        calendar.allowsMultipleSelection = true

        let tabBar = tabBarController as! TabBarViewController
        totalDays = tabBar.totalDays
        daysRemaining.text = "Days Remaining: \(totalDays)"
        
        newWorkoutDates.removeAll()
        formatter.dateFormat = "MM-dd-yyyy"
        calendarStart = formatter.string(from: Date().startOfNextWeekDate)
        calendarEnd = formatter.string(from: Date().endOfNextWeekDate)
        
        let datesInWeek = Date().dateToString(Date().datesInNextWeek())
        scheduleDates = scheduleDates.filter { !datesInWeek.contains($0) }
        
        
        calendar.reloadData()
    }
}
// MARK: Calendar Functions
extension CalendarVC{
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "MM-dd-yyyy"
        let selectedDay = formatter.string(from: date)
        
        if newWorkoutDates.contains(selectedDay){
        }else{
            newWorkoutDates.append(selectedDay)
            totalDays -= 1
            daysRemaining.text = "Days Remaining: \(totalDays)"
        }
        
        if totalDays == 0{
            doneButton.isEnabled = true
        }else{
            doneButton.isEnabled = false
        }

        
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "MM-dd-yyyy"
        let selectedDay = formatter.string(from: date)
        newWorkoutDates = newWorkoutDates.filter{ $0 != selectedDay }
        totalDays += 1
        daysRemaining.text = "Days Remaining: \(totalDays)"
        
        if totalDays == 0{
            doneButton.isEnabled = true
        }else{
            doneButton.isEnabled = false
        }
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
    func minimumDate(for calendar: FSCalendar) -> Date {
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.date(from: calendarStart)!
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.date(from: calendarEnd)!
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
    
    func writeCalendarDates(_ dates: [String]){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("calendar").document("schedule")
        for count in 0 ... scheduleDates.count - 1{
            docRef.setData([scheduleDates[count] : scheduleDates[count]], merge: true)
        }
    }
    
    func eraseWeek(_ selectedWeek: [String]){
        scheduleDates = scheduleDates.filter { !selectedWeek.contains($0) }
    }
}
