//
//  WorkoutHomeVC.swift
//  NAV
//
//  Created by Alex Chen on 8/2/23.
//

import Foundation
import UIKit

class WorkoutHomeVC: UIViewController{
    
    private let refreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.register(WorkoutHomeTableViewCell.nib(), forCellReuseIdentifier: WorkoutHomeTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        configureMenu()
        super.viewDidLoad()
    }
    
    func configureMenu(){
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
    @objc func refreshTableView(_ sender: Any){
        print("refresh Menu")
        refreshControl.endRefreshing()
    }
}
// MARK: Table View Functions
extension WorkoutHomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutHomeTableViewCell.identifier, for: indexPath) as! WorkoutHomeTableViewCell
        cell.previewTableView.rowHeight = UITableView.automaticDimension

        
        cell.goToLoadout.addTarget(self, action: #selector(self.goToLoadout(_:)), for: .touchUpInside)
        cell.goToExercises.addTarget(self, action: #selector(self.goToSkillTree(_:)), for: .touchUpInside)
        cell.goToStartWorkout.addTarget(self, action: #selector(self.goToStartWorkout(_:)), for: .touchUpInside)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

// MARK: Segue Functions
extension WorkoutHomeVC{
    @objc func goToLoadout(_ sender: Any){
        self.performSegue(withIdentifier: "goToLoadout", sender: self)
    }
    @objc func goToStartWorkout(_ sender: Any){
        self.performSegue(withIdentifier: "goToStartWorkout", sender: self)
    }
    @objc func goToSkillTree(_ sender: Any){
        self.performSegue(withIdentifier: "goToSkillTree", sender: self)
    }
}
