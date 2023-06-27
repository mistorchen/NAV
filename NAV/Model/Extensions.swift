//
//  Extensions.swift
//  NAV
//
//  Created by Alex Chen on 6/7/23.
//

import Foundation
import UIKit

extension Date {
    var today: Date{
        return Date()
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var dayNumberOfWeek: Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday!
    }
    var startOfWeekDate: Date{
        return Calendar.current.date(byAdding: .day, value:-(Date().dayNumberOfWeek - 1),  to: self)!
    }
    var endOfWeekDate: Date{
        return Calendar.current.date(byAdding: .day, value: (7 - Date().dayNumberOfWeek), to: self)!
    }
    var startOfNextWeekDate: Date{
        return Calendar.current.date(byAdding: .day, value:-(Date().dayNumberOfWeek - 1) + 7,  to: self)!
    }
    var endOfNextWeekDate: Date{
        return Calendar.current.date(byAdding: .day, value: (7 - Date().dayNumberOfWeek)+7, to: self)!
    }
    var startOfMonthDate: Date{
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    var endOfMonthDate: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: Date().startOfMonthDate)!
    }
    func datesInWeek() -> [Date]{
        var startDate = Date().startOfWeekDate
        let endDate = Date().endOfWeekDate
        var dates: [Date] = []
        
        while startDate <= endDate {
            dates.append(startDate)
            startDate = Calendar.current.date(byAdding: .day, value:1,  to: startDate)!
        }
        return dates
    }
    func datesInNextWeek() -> [Date]{
        var startDate = Date().startOfNextWeekDate
        let endDate = Date().endOfNextWeekDate
        var dates: [Date] = []
        
        while startDate <= endDate {
            dates.append(startDate)
            startDate = Calendar.current.date(byAdding: .day, value:1,  to: startDate)!
        }
        return dates
    }
    func dateToString(_ dates: [Date]) -> [String]{
        let formatter = DateFormatter()

        formatter.dateFormat = "MM-dd-yyyy"
        var formattedArray: [String] = []
        for count in 0 ... dates.count-1{
            formattedArray.append(formatter.string(from: dates[count]))
        }
        return formattedArray
    }
    func stringToDate(_ dates: [String]) -> [Date]{
        let formatter = DateFormatter()
        var formattedArray: [Date] = []
        for count in 0 ... dates.count-1{
            formattedArray.append(formatter.date(from: dates[count])!)
        }
        return formattedArray
    }
    
}

class DifficultyButtonGesture: UITapGestureRecognizer {
    var exerciseIndex = Int()
}
