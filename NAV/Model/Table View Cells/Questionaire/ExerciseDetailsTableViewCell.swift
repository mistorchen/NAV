//
//  ExerciseDetailsTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 6/27/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import youtube_ios_player_helper
import Charts

class ExerciseDetailsTableViewCell: UITableViewCell, YTPlayerViewDelegate, ChartViewDelegate{

    static let identifier = "ExerciseDetailsTableViewCell"
    
    static func nib() ->UINib{
        return UINib(nibName: ExerciseDetailsTableViewCell.identifier, bundle: nil)
    }
    
    let db = Firestore.firestore()
    
    
    var weights = [ChartDataEntry]()
    var weightLifted = [Int]()
    var programIndex = [Int]()
    
    
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var YTPlayer: YTPlayerView!
    @IBOutlet weak var previousWeightChart: LineChartView!
    
    
    
    
    
    override func awakeFromNib() {
        
        previousWeightChart.delegate = self
        YTPlayer.delegate = self
        
        super.awakeFromNib()
        // Initialization code
        print(weights)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setLineChart(){
        for count in 0 ... weightLifted.count - 1{
            weights.append(ChartDataEntry(x: Double(weightLifted[count]), y: Double(weightLifted[count])))
        }
        let set = LineChartDataSet(entries: weights)
        set.colors = ChartColorTemplates.pastel()
        let dataSet = LineChartData(dataSet: set)
        previousWeightChart.data = dataSet
        previousWeightChart.notifyDataSetChanged()
        previousWeightChart.reloadInputViews()
        set.notifyDataSetChanged()
        dataSet.notifyDataChanged()

        previousWeightChart.notifyDataSetChanged()
    }
    
    func getWeights(_ exerciseID: String){
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("exerciseInventory").document(exerciseID)
        docRef.getDocument { document, error in
            if let error = error{
                print(error)
            }else{
                if let document = document{
                    let programs = document["programs"] as! [Int]
                    
                    for counter in 0...programs.count - 1{
                        self.weightLifted = self.weightLifted + (document["p\(programs[counter])Volume"] as! [Int])
                    }
                    
                    self.setLineChart()
                }
            }
        }
    }
    
    
    
}
