//
//  HomeScreenTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 8/2/23.
//

import UIKit
import FSCalendar

class HomeTableViewCell: UITableViewCell {

    static let identifier = "HomeTableViewCell"
    
    let formatter = DateFormatter()
    var streakDates = [String]()
    var scheduleDates = [String]()

    

    @IBOutlet weak var calendar: FSCalendar!
    
    static func nib() ->UINib{
        return UINib(nibName: HomeTableViewCell.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//// MARK: Calendar Functions
extension HomeTableViewCell{
    func configureCalendar(){
        calendar.allowsSelection = false
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        formatter.dateFormat = "MM-dd-yyyy"
        let streakDay = formatter.string(from: date)

        if streakDates.contains(streakDay){
            return .green
        }
        return nil
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        formatter.dateFormat = "MM-dd-yyyy"
        let scheduleDate = formatter.string(from: date)

        if scheduleDates.contains(scheduleDate){
            return 1
        }
        return 0
    }

}
