//
//  CurrentWorkoutVC.swift
//  NAV
//
//  Created by Alex Chen on 4/11/23.
//

import UIKit
import WebKit
import youtube_ios_player_helper
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class CurrentWorkoutVC: UIViewController, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate{
    
    let db = Firestore.firestore()
    var selectedProgram = [ProgramExerciseInfo]()
    
    var exercisePerBlock = 0
    var exerciseIndex = Int()
    var blockIndex = Int()
    var sizeOfBlocks = [Int]()
    var day = Int()
    var dayArray = [Int]()
    var completedCount = Int()
    var weightWritten = Int()
    var week = Int()
    
    var sets = 1
    
    var rowsPerBlock = [Int]()
    var programID = Int()
    
    var unlockNext: [Int] = []
    
    
    
    
    
    @IBOutlet weak var exerciseTable: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var blockExerciseTitle: UILabel!
    
    override func viewDidLoad() {
        setVariables()
        setSelectedProgram()
        blockExerciseTitle.text = ""
        exerciseTable.register(CWExerciseTableViewCell.nib(), forCellReuseIdentifier: CWExerciseTableViewCell.identifier)
        exerciseTable.register(CWSingleSetTableViewCell.nib(), forCellReuseIdentifier: CWSingleSetTableViewCell.identifier)
        exerciseTable.register(CWDifficultyTableViewCell.nib(), forCellReuseIdentifier: CWDifficultyTableViewCell.identifier)
        
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        
        
        
        setRowsPerBlock()
        
        configureNext()
        setTitle(blockIndex)
        exerciseTable.backgroundColor = UIColor.clear
        exerciseTable.reloadData()
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    
    @IBAction func nextBlock(_ sender: UIButton) {
        exerciseTable.setContentOffset(.zero, animated: true)
        if blockIndex < sizeOfBlocks.count-1{
            exercisePerBlock = 0
            blockIndex += 1
            setTitle(blockIndex)
            configureNext()
            exerciseTable.reloadData()
            if blockIndex == sizeOfBlocks.count-1{
                nextButton.setTitle("Complete Workout!", for: .normal)
            }
            
        }else if blockIndex == ProgramOutline.program1().blockSizes.count-1 {
            self.performSegue(withIdentifier: "goToFinishedWorkoutVC", sender: self)
        }
        
    }
    
    
    
    
    func setSelectedProgram(){
        let tabBar = tabBarController as! TabBarViewController
        day = tabBar.currentDay
        switch tabBar.currentDay{
        case 1:
            selectedProgram = tabBar.day1Program
            for count in 0...selectedProgram.count-1{
                detBlocks(selectedProgram[count].block)
            }
        case 2:
            selectedProgram = tabBar.day2Program
            for count in 0...selectedProgram.count-1{
                detBlocks(selectedProgram[count].block)
            }
        case 3:
            selectedProgram = tabBar.day3Program
            for count in 0...selectedProgram.count-1{
                detBlocks(selectedProgram[count].block)
            }
        case 4:
            selectedProgram = tabBar.day4Program
            for count in 0...selectedProgram.count-1{
                detBlocks(selectedProgram[count].block)
            }
        case 5:
            selectedProgram = tabBar.day5Program
            for count in 0...selectedProgram.count-1{
                detBlocks(selectedProgram[count].block)
            }
        default:
            print("set selected Program Error")
        }
        print(selectedProgram)
        
        
    }
    
    func detBlocks(_ block: Int){
        sizeOfBlocks.append(0)
        if block == 0{
            sizeOfBlocks[0] += 1
        }else if block == 1{
            sizeOfBlocks[1] += 1
        }else if block == 2{
            sizeOfBlocks[2] += 1
        }else if block == 3{
            sizeOfBlocks[3] += 1
        }else if block == 4{
            sizeOfBlocks[4] += 1
        }else if block == 5{
            sizeOfBlocks[5] += 1
        }else if block == 6{
            sizeOfBlocks[6] += 1
        }else if block == 7{
            sizeOfBlocks[7] += 1
        }
        
    }
    
    //    func getWorkout(){
    //        // Reads from users monthly program based on day, default day is 1
    //        // Appends exercises to exercises: [ExerciseInfo] in descending order (order of program)
    //        let docRef = db.collection("/users/\(Auth.auth().currentUser!.uid)/\(findMonth())/day\(programDay)/exercises").order(by: "order", descending: false)
    //
    //        docRef.getDocuments { collection, error in
    //            if let error = error{
    //                print(error)
    //            }else{
    //                for document in collection!.documents{
    //                    self.selectedProgram.append(ExerciseInfo(name: document["name"] as! String, sets: document["sets"] as! Int , reps: document["reps"] as! Int, order: document["order"] as! Int, docID: document.documentID, block: document["block"] as! Int))
    //
    //                }
    //            }
    //        }
    //    }
    
    
    
    
    
    func findMonth()-> String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return(nameOfMonth)
    }
    func setTitle(_ block: Int){
        blockExerciseTitle.text = "Block: \(block+1) Exercises: \(sizeOfBlocks[block])"
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func numberOfRows() -> Int{
        var numberOfRows = 0
        for count in 0 ..< sizeOfBlocks[blockIndex]{
            numberOfRows = numberOfRows + selectedProgram[exerciseIndex + count].sets + 2
        }
        return numberOfRows
    }
    
    func setRowsPerBlock(){
        for count in 0 ..< sizeOfBlocks[blockIndex]{
            rowsPerBlock.append(66)
            for set in 0 ..< selectedProgram[exerciseIndex].sets{
                rowsPerBlock.append(set + 1)
            }
            rowsPerBlock.append(88)
        }
    }
    func indexToOrder(_ index: Int) -> Int{
        var exerciseOrder = 0
        
        for i in 0 ..< blockIndex{
            exerciseOrder = exerciseOrder + sizeOfBlocks[i]
        }
        exerciseOrder += index / 5
        return exerciseOrder
    }
}
    


extension CurrentWorkoutVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sizeOfBlocks.isEmpty{
            return 0
        }
        
        
        return numberOfRows()
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exerciseID = indexToOrder(indexPath.row)
        let currentWorkoutPath = "/users/\(Auth.auth().currentUser!.uid)/programInventory/programs/program\(programID)/currentWorkout"
        let inventoryPath = "/users/\(Auth.auth().currentUser!.uid)/exerciseInventory/\(selectedProgram[exerciseID].docID)"

        
        
        if rowsPerBlock[indexPath.row] == 66 && exercisePerBlock != sizeOfBlocks[blockIndex]{
            let detailCell = tableView.dequeueReusableCell(withIdentifier: CWExerciseTableViewCell.identifier) as! CWExerciseTableViewCell
            detailCell.selectedProgram = selectedProgram
            detailCell.exerciseName.text = "\(selectedProgram[exerciseID].name)"
            return detailCell
        }
        if rowsPerBlock[indexPath.row] == 88{
            let difficultyCell = tableView.dequeueReusableCell(withIdentifier: CWDifficultyTableViewCell.identifier) as! CWDifficultyTableViewCell
            difficultyCell.selectedProgram = selectedProgram
            
            difficultyCell.difficulty1.addTarget(self, action: #selector(completeDifficulty(_:)), for: .touchUpInside)
            difficultyCell.difficulty1.tag = indexPath.row
            difficultyCell.difficulty2.addTarget(self, action: #selector(completeDifficulty(_:)), for: .touchUpInside)
            difficultyCell.difficulty2.tag = indexPath.row
            difficultyCell.difficulty3.addTarget(self, action: #selector(completeDifficulty(_:)), for: .touchUpInside)
            difficultyCell.difficulty3.tag = indexPath.row
            difficultyCell.difficulty4.addTarget(self, action: #selector(completeDifficulty(_:)), for: .touchUpInside)
            difficultyCell.difficulty4.tag = indexPath.row
            difficultyCell.difficulty5.addTarget(self, action: #selector(completeDifficulty(_:)), for: .touchUpInside)
            difficultyCell.difficulty5.tag = indexPath.row

            difficultyCell.currentWorkoutPath = currentWorkoutPath
            difficultyCell.inventoryPath = inventoryPath
            
            
            if exercisePerBlock != sizeOfBlocks[blockIndex] - 1{
                exerciseIndex += 1
                exercisePerBlock += 1
            }
            sets = 1
            
            
            return difficultyCell
        }else{
            let setsCell = tableView.dequeueReusableCell(withIdentifier: CWSingleSetTableViewCell.identifier) as! CWSingleSetTableViewCell
            setsCell.selectedProgram = selectedProgram
            setsCell.setsLabel.text = "\(rowsPerBlock[indexPath.row])"
            setsCell.repsLabel.text = "\(selectedProgram[exerciseID].reps)"
            
            setsCell.weightTextField.tag = indexPath.row
            setsCell.weightTextField.addTarget(self, action: #selector(completeWeight(_:)), for: .editingDidEnd)
            
            setsCell.currentWorkoutPath = currentWorkoutPath
            setsCell.inventoryPath = inventoryPath
            
            setsCell.configureButton()
            
            sets += 1
            
            return setsCell
        }
        
        
    }
    
        
        
//        if exercisePerBlock != sizeOfBlocks[blockIndex]{
            
            
            
            
            
            //
            //        if cell.weightWritten >= exercises[exerciseIndex].sets{
            //            print("\(exercises[indexPath.row].name) works")
            //            nextButton.isHidden = false
            //        }
            //
            
            //
            //            cell.exerciseName.text = selectedProgram[exerciseIndex].name
            //            cell.repCount.text = String(selectedProgram[exerciseIndex].reps)
            //            cell.reps = selectedProgram[exerciseIndex].reps
            //            cell.setCount.text = String(selectedProgram[exerciseIndex].sets)
            //            cell.currentWorkoutPath = "/users/\(Auth.auth().currentUser!.uid)/programInventory/programs/program\(programID)/currentWorkout"
            //            cell.inventoryWritePath = "/users/\(Auth.auth().currentUser!.uid)/exerciseInventory/\(selectedProgram[exerciseIndex].docID)"
            //
            //
            //            cell.exerciseIndex = exerciseIndex
            //            cell.programDay = day
            //            cell.programID = programID
            //            cell.week = week
            //
            //
            //            //Reset Interactible Fields Color
            //            cell.resetTextFields()
            //            cell.resetButtons()
            //
            //            // Gestures
            //            let easyButtonGesture = DifficultyButtonGesture(target: self, action:  #selector (self.testFunction (_:)))
            //            easyButtonGesture.cancelsTouchesInView = false
            //            easyButtonGesture.exerciseIndex = indexPath.row
            //            cell.easyButton.addGestureRecognizer(easyButtonGesture)
            //
            //            let medButtonGesture = DifficultyButtonGesture(target: self, action:  #selector (self.testFunction (_:)))
            //            medButtonGesture.cancelsTouchesInView = false
            //            medButtonGesture.exerciseIndex = indexPath.row
            //            cell.mediumButton.addGestureRecognizer(medButtonGesture)
            //
            //            let hardButtonGesture = DifficultyButtonGesture(target: self, action:  #selector (self.testFunction (_:)))
            //            hardButtonGesture.cancelsTouchesInView = false
            //            hardButtonGesture.exerciseIndex = indexPath.row
            //            cell.hardButton.addGestureRecognizer(hardButtonGesture)
            //
            //            // Find Saved Weight if Available
            //            let index = exerciseIndex
            //            let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(programID)").document("currentWorkout")
            //            docRef.getDocument { document, error in
            //                if let error = error{
            //                    print(error)
            //                }else{
            //
            //                    if let weight = document!["e\(index)s1"]{
            //                        cell.set1Field.text = "\(weight)"
            //                        cell.weightLifted[0] = weight as! Int
            //                        cell.checkButtonStatus()
            //                    }
            //                    if let weight = document!["e\(index)s2"]{
            //                        cell.set2Field.text = "\(weight)"
            //                        cell.weightLifted[1] = weight as! Int
            //                        cell.checkButtonStatus()
            //                    }
            //                    if let weight = document!["e\(index)s2"]{
            //                        cell.set3Field.text = "\(weight)"
            //                        cell.weightLifted[2] = weight as! Int
            //                        cell.checkButtonStatus()
            //                    }
            //                    let difficulty = document!["e\(index)d"] as! Int
            //                        cell.buttonSelected(difficulty)
            //
            //
            //
            //                        self.unlockNext[indexPath.row] = 0
            //                        if self.unlockNext.allSatisfy({ $0 == 0 }) == true{
            //                            self.nextButton.isEnabled = true
            //                            self.nextButton.backgroundColor = K.color.beige
            //                        }
            //                    }
            //                }
            //
            //
            //
            //
            
            
            
//        }
        
        
    @objc func completeDifficulty(_ sender: UIButton){
        if unlockNext[sender.tag] == 1{
            unlockNext[sender.tag] = 0
        }
        if unlockNext.allSatisfy({ $0 == 0 }) == true{
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor(red: CGFloat(216.0/255.0), green: CGFloat(196.0/255.0), blue: CGFloat(182.0/255.0), alpha: 1)
        }
    }
    @objc func completeWeight(_ sender: UITextField){
        if unlockNext[sender.tag] == 1{
            unlockNext[sender.tag] = 0
            print(unlockNext)
        }
        if unlockNext.allSatisfy({ $0 == 0 }) == true{
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor(red: CGFloat(216.0/255.0), green: CGFloat(196.0/255.0), blue: CGFloat(182.0/255.0), alpha: 1)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if rowsPerBlock[indexPath.row] == 66{
            return 90
        }else if rowsPerBlock[indexPath.row] == 88{
            return 60
        }
        return 35
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFinishedWorkoutVC"{
            let destinationVC = segue.destination as! FinishedWorkoutVC
            destinationVC.day = day
        }
    }
    
    
}
// MARK: Button Configuration
extension CurrentWorkoutVC{
    
    func configureNext(){
        unlockNext.removeAll()
        nextButton.layer.cornerRadius = 10
        nextButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 18.0)
        nextButton.isEnabled = !nextButton.isEnabled
        nextButton.backgroundColor = .gray
        for _ in 0 ..< sizeOfBlocks[blockIndex]{
            unlockNext.append(0)
            for _ in 0 ..< selectedProgram[exerciseIndex].sets{
                unlockNext.append(1)
            }
            unlockNext.append(1)
        }
        print(unlockNext)
    }
    func setVariables(){
        let tabBar = tabBarController as! TabBarViewController
        day = tabBar.currentDay
        programID = tabBar.programID
        week = tabBar.week
    }
}
