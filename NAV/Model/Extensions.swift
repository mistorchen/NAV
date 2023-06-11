//
//  Extensions.swift
//  NAV
//
//  Created by Alex Chen on 6/7/23.
//

import Foundation
import UIKit

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
}

class DifficultyButtonGesture: UITapGestureRecognizer {
    var exerciseIndex = Int()
}
