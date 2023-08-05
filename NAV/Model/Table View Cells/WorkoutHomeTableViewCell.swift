//
//  WorkoutHomeTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 8/2/23.
//

import UIKit

class WorkoutHomeTableViewCell: UITableViewCell {

    static let identifier = "WorkoutHomeTableViewCell"
    
    let workoutDays = 5
    var showWorkout = true
    
    
    @IBOutlet weak var previewTableView: UITableView!
    @IBOutlet weak var goToExercises: UIButton!
    @IBOutlet weak var goToLoadout: UIButton!
    @IBOutlet weak var goToStartWorkout: UIButton!
    
    
    static func nib() ->UINib{
        return UINib(nibName: WorkoutHomeTableViewCell.identifier, bundle: nil)
    }

    override func awakeFromNib() {
        previewTableView.register(PreviewDayTableViewCell.nib(), forCellReuseIdentifier: PreviewDayTableViewCell.identifier)
        previewTableView.dataSource = self
        previewTableView.delegate = self
        configureTableView()
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension WorkoutHomeTableViewCell: UITableViewDelegate, UITableViewDataSource{
    func configureTableView(){
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("Preview Workout", for: .normal)
        button.addTarget(self, action: #selector(handleDropDownMenu), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        return button
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showWorkout ? workoutDays : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PreviewDayTableViewCell.identifier, for: indexPath) as! PreviewDayTableViewCell
        

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    
//    @objc func performSegue(_ sender: UITapGestureRecognizer){
//        self.performSegue(withIdentifier: "goToCalendar", sender: self)
//        
//    }
}
extension WorkoutHomeTableViewCell{
    @objc func handleDropDownMenu(){
        showWorkout = !showWorkout
        
        var indexPaths = [IndexPath]()
        
        for days in 0 ..< workoutDays{
            indexPaths.append(IndexPath(row: days, section: 0))
        }
        
        if showWorkout{
            previewTableView.insertRows(at: indexPaths, with: .fade)
        }else{
            previewTableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
}
