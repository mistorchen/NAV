//
//  AchievementsVC.swift
//  NAV
//
//  Created by Alex Chen on 6/28/23.
//

import Foundation
import UIKit

class AchievementsVC: UIViewController{
    
    var unlockedAchievements = [Achievements.AchievementDisplay]()
    
    
    
    @IBOutlet weak var achievementsTable: UITableView!
    override func viewDidLoad(){
        achievementsTable.register(AchievementsTableViewCell.nib(), forCellReuseIdentifier: AchievementsTableViewCell.identifier)
        achievementsTable.dataSource = self
        achievementsTable.delegate = self
        setData()
        
    }
    
    func setData(){
        let achievements = Achievements()
        achievements.getUnlockedAchievements { (unlockedAchievements) in
            self.unlockedAchievements = unlockedAchievements
            self.achievementsTable.reloadData()
        }

    }
    
    
    
    
    
    
    
    
    
}

extension AchievementsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unlockedAchievements.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AchievementsTableViewCell.identifier, for: indexPath) as! AchievementsTableViewCell
        
        cell.nameLabel.text = unlockedAchievements[indexPath.row].name!
        cell.descriptionLabel.text = unlockedAchievements[indexPath.row].description!
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)    
    }
    
}
