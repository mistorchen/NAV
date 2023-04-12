//
//  HomeVC.swift
//  NAV
//
//  Created by Alex Chen on 2/9/23.
//

import Foundation
import UIKit


class ProgramMaker: UIViewController{
    
    var program: [String : String] = [:]
    
    @IBOutlet weak var blocksLabel: UILabel!
    
    @IBOutlet weak var setsLabel: UILabel!
    
    @IBOutlet weak var repsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        newProgram()
    }
    func newProgram(){
        let blocks = Int.random(in: 3...4) // Determines a random block number between 3 and 4
        
        for i in 1...blocks{ // Runs through a loop depending on block size
            var block: [Int : String] = [:] // Creates a temporary exercise holder for the current block

            
            if i != 4{
                for j in 1 ... 3 { // Adds three exercises to temp block
                    block.updateValue("Exercise \(j)", forKey: j)

                }
            }else{ // Adds cardio to program
                program.updateValue("Run", forKey: "Cardio")
            }
            
            for x in 1...3{ // adds DEFAULT VALUE exercise count to overall program
                program.updateValue(block[x] ?? "ERROR", forKey: "Block \(i), Exercise \(x)")
            }
        }
        
        
        
        
        for i in 1...blocks{ // Reads program in order
            if i != 4{
                for j in 1...3{
                    print("Block \(i): \(program["Block \(i), Exercise \(j)"]!)")
                }
            }else{
                print("Block \(i): \(program["Cardio"]!)")

            }
            
        }
    }
}

