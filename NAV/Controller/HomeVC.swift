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


class HomeVC: UIViewController, FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource{
    
    //    @IBOutlet weak var calendar: FSCalendar!
    //    @IBOutlet weak var checkInButton: UIButton!
    //    @IBOutlet weak var editLoadout: UIButton!
    //    @IBOutlet weak var newProgram: UIButton!
    //    @IBOutlet weak var badgesButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let formatter = DateFormatter()
    var streakDates: [String] = []
    var scheduleDates: [String] = []
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        tableView.register(HomeTableViewCell.nib(), forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        //        newProgram.isEnabled = false
        //        newProgram.isHidden = true
        //        calendar.delegate = self
        //        calendar.dataSource = self
        //        configureCalendar()
        configureMenuButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            //            self.programMakerAccess()
            //            self.calendar.reloadData()
        }
        super.viewDidLoad()
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        let tabBar = tabBarController as! TabBarViewController
        
        cell.streakDates = tabBar.streakDates
        cell.scheduleDates = tabBar.scheduleDates
        let gestureRec = UITapGestureRecognizer(target: self, action:  #selector (self.performSegue (_:)))
        cell.calendar.addGestureRecognizer(gestureRec)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func performSegue(_ sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "goToCalendar", sender: self)
        
    }
}


//
//

//
//// MARK:  Menu Buttons
extension HomeVC{
    func configureMenuButtons(){
        //        editLoadout.titleLabel!.textAlignment = .center
        //        editLoadout.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 13.0)
        //        editLoadout.titleLabel!.adjustsFontSizeToFitWidth = true
        //        editLoadout.layer.cornerRadius = 15
        //
        //        checkInButton.titleLabel!.textAlignment = .center
        //        checkInButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 13.0)
        //        checkInButton.titleLabel!.adjustsFontSizeToFitWidth = true
        //        checkInButton.layer.cornerRadius = 15
        //
        //        if Date().dayNumberOfWeek == 1{
        //            checkInButton.setTitle("Weekly Check In", for: .normal)
        //        }else{
        //            checkInButton.setTitle("Daily Check In", for: .normal)
        //        }
        //
        //
        //
        //        badgesButton.titleLabel!.textAlignment = .center
        //        badgesButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 13.0)
        //        badgesButton.titleLabel!.adjustsFontSizeToFitWidth = true
        //        badgesButton.layer.cornerRadius = 15
        //
        //        newProgram.layer.cornerRadius = 15
        //
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
    }
    //    func programMakerAccess(){
    //        let tabBar = tabBarController as! TabBarViewController
    //        if tabBar.newProgram == true{
    //            newProgram.isEnabled = true
    //            newProgram.isHidden = false
    //        }
    //    }
    //
    //    @IBAction func editLoadout(_ sender: UIButton) {
    //        self.performSegue(withIdentifier: "goToLoadout", sender: self)
    //    }
    //    @IBAction func viewAccount(_ sender: UIButton) {
    //        self.performSegue(withIdentifier: "goToAccount", sender: self)
    //    }
    //    @IBAction func goToAchievements(_ sender: UIButton) {
    //        self.performSegue(withIdentifier: "goToAchievements", sender: self)
    //    }
    //    @IBAction func goToCheckIn(_ sender: UIButton) {
    //        if Date().dayNumberOfWeek == 1{
    //            self.performSegue(withIdentifier: "goToWeeklyCheckIn", sender: self)
    //
    //        }else{
    //            self.performSegue(withIdentifier: "goToDailyCheckIn", sender: self)
    //        }
    //    }
    //    @IBAction func goToProgramMaker(_ sender: UIButton) {
    //        self.performSegue(withIdentifier: "goToProgramMaker", sender: self)
    //
    //    }
    @objc func refreshTableView(_ sender: Any){
        print("refresh Menu")
        refreshControl.endRefreshing()
    }
}
