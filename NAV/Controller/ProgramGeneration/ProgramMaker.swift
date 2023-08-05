//
//  HomeVC.swift
//  NAV
//
//  Created by Alex Chen on 2/9/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


class ProgramMaker: UIViewController{
    
    let db = Firestore.firestore()
    
    let selectedTree = [K.s.skillTree.player, K.s.skillTree.upper, K.s.skillTree.lower, K.s.skillTree.plyo, K.s.skillTree.core, K.s.skillTree.arms]
    
    //Initialize empty Variables
    var userInfo: UserInfo?
    var totalDays = 0
    var reps = 0
    var levels: [String : Int] = [:]
    var currentProgramID = Int()
    
    
    
    var done1Reading = false
    var done2Reading = false
    var done3Reading = false
    var done4Reading = false
    
    
    var temp1Exercises: [String] = []
    var temp2Exercises: [String] = []
    var temp3Exercises: [String] = []
    var temp4Exercises: [String] = []
    
    
    //    var day1Exercises: [String] = []
    //    var day2Exercises: [String] = []
    //    var day3Exercises: [String] = []
    //    var day4Exercises: [String] = []
    
    
    var day1Blocks: [Int] = []
    var day2Blocks: [Int] = []
    var day3Blocks: [Int] = []
    var day4Blocks: [Int] = []
    
    
    var exerciseCounters = [0,0,0,0,0]
    var blockCounters = [1,1,1,1,1]
    
    
    
    
    
    // MARK: V2 VARIABLES
    var blocks = String()
    var selectedSplit = String() // Full body day Split
    var duration = Int()
    
    var plyoExercises = [FirestoreExerciseInfo]()
    var upperExercises = [FirestoreExerciseInfo]()
    var lowerExercises = [FirestoreExerciseInfo]()
    var coreExercises = [FirestoreExerciseInfo]()
    var armsExercises = [FirestoreExerciseInfo]()
    
    var buildingDay = 0
    
    var day1Exercises = [ChosenExercise]()
    var day2Exercises = [ChosenExercise]()
    var day3Exercises = [ChosenExercise]()
    var day4Exercises = [ChosenExercise]()
    
    var day1CompleteWorkout = [CompleteExerciseInfo]()
    var day2CompleteWorkout = [CompleteExerciseInfo]()
    var day3CompleteWorkout = [CompleteExerciseInfo]()
    var day4CompleteWorkout = [CompleteExerciseInfo]()
    
    
    @IBOutlet weak var numberOfDays: UILabel!
    @IBOutlet weak var dayStepper: UIStepper!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var dropDownButton: UIButton!
    
    @IBOutlet weak var shortDuration: UIButton!
    @IBOutlet weak var mediumDuration: UIButton!
    @IBOutlet weak var longDuration: UIButton!
    
    @IBOutlet weak var totalDaysDescription: UILabel!
    @IBOutlet weak var blocksDescription: UILabel!
    @IBOutlet weak var totalExercisesDescription: UILabel!
    @IBOutlet weak var exercisesPerBlock: UILabel!
    
    override func viewDidLoad() {
        
        let tabBar = tabBarController as! TabBarViewController
        currentProgramID = tabBar.programID
        getUserInfo()
        setDropDown()
        dayStepper.value = 3.0
        numberOfDays.text = "Days: 3"
        finishedButton.isEnabled = false
        super.viewDidLoad()
    }
    
    @IBAction func dayStepper(_ sender: UIStepper) {
        if sender.value == 0{
            totalDays = 1
            sender.value = 1
        }
        if sender.value > 6{
            totalDays = 6
            sender.value = 6
        }else{
            totalDays = Int(sender.value)
        }
        numberOfDays.text = "Days: \(totalDays)"
        totalDaysDescription.text = "Total Days: \(totalDays)"
    }
    
    @IBAction func shortSelected(_ sender: Any) {
        durationSelected(1)
    }
    
    @IBAction func mediumSelected(_ sender: UIButton) {
        durationSelected(2)
    }
    
    @IBAction func longSelected(_ sender: UIButton) {
        durationSelected(3)
    }
    
    @IBAction func useSuggestedProgram(_ sender: UIButton) {
        setSuggested()
    }
    @IBAction func finishedButton(_ sender: UIButton) {
        buildingDay = 1
        dayProgramGen()
        //        generateProgramDetails()
        //        self.performSegue(withIdentifier: "goToGenerating", sender: self)
    }
    
    func durationSelected(_ length: Int){
        switch length{
        case 1:
            duration = 1
            shortDuration.backgroundColor = K.color.beige
            mediumDuration.backgroundColor = .gray
            longDuration.backgroundColor = .gray
            updateDescription()
        case 2:
            duration = 2
            shortDuration.backgroundColor = .gray
            mediumDuration.backgroundColor = K.color.beige
            longDuration.backgroundColor = .gray
            updateDescription()
        case 3:
            duration = 3
            shortDuration.backgroundColor = .gray
            mediumDuration.backgroundColor = .gray
            longDuration.backgroundColor = K.color.beige
            updateDescription()
        default:
            print("error")
        }
    }
    func setDropDown(){
        let optionClosure = {(action : UIAction) in
            if action.title == "Choose an option"{
                
            }else{
                if action.title == "Push / Pull / Legs"{
                    self.selectedSplit = "PPL"
                    self.updateDescription()
                }else if action.title == "Upper Body / Lower Body"{
                    self.selectedSplit = "UL"
                    self.updateDescription()
                }else if action.title == "Full Body"{
                    self.selectedSplit = "FULL"
                    self.updateDescription()
                }
            }
            
        }
        
        dropDownButton.menu = UIMenu(children: [
            UIAction(title: "Choose an option", state: .on, handler: optionClosure),
            UIAction(title: "Push / Pull / Legs", handler: optionClosure),
            UIAction(title: "Upper Body / Lower Body", handler: optionClosure),
            UIAction(title: "Full Body", handler: optionClosure),
        ])
        dropDownButton.showsMenuAsPrimaryAction = true
        dropDownButton.changesSelectionAsPrimaryAction = true
    }
    
    func setSuggested(){
        durationSelected(2)
        totalDays = 3
        numberOfDays.text = "Days: \(totalDays)"
        totalDaysDescription.text = "Total Days: \(totalDays)"
        selectedSplit = "FULL"
        let optionClosure = {(action : UIAction) in
            if action.title == "Choose an option"{
                
            }else{
                if action.title == "Push / Pull / Legs"{
                    self.selectedSplit = "PPL"
                    self.updateDescription()
                }else if action.title == "Upper Body / Lower Body"{
                    self.selectedSplit = "UL"
                    self.updateDescription()
                }else if action.title == "Full Body"{
                    self.selectedSplit = "FULL"
                    self.updateDescription()
                }
            }
            
        }
        
        dropDownButton.menu = UIMenu(children: [
            UIAction(title: "Choose an option", handler: optionClosure),
            UIAction(title: "Push / Pull / Legs", handler: optionClosure),
            UIAction(title: "Upper Body / Lower Body", handler: optionClosure),
            UIAction(title: "Full Body", state: .on, handler: optionClosure),
        ])
        dropDownButton.showsMenuAsPrimaryAction = true
        dropDownButton.changesSelectionAsPrimaryAction = true
    }
    
    
    
    
    
    
    func updateDescription(){
        switch duration{
        case 1:
            blocks = "SHORT"
            blocksDescription.text = "Blocks: 3"
            exercisesPerBlock.text = "Exercises per Block: 2-3"
            totalExercisesDescription.text = "Total Number of Exercises: ~7"
        case 2:
            blocks = "MED"
            blocksDescription.text = "Blocks: 4"
            exercisesPerBlock.text = "Exercises per Block: 2-3"
            totalExercisesDescription.text = "Total Number of Exercises: ~10"
        case 3:
            blocks = "LONG"
            blocksDescription.text = "Blocks: 5"
            exercisesPerBlock.text = "Exercises per Block: 2-3"
            totalExercisesDescription.text = "Total Number of Exercises: ~13"
        default:
            print("error")
        }
    }
    
    
    
}

extension ProgramMaker{
    func dayProgramGen(){
        let firestoreCommands = FirestoreCommands(userInfo: userInfo)
        if buildingDay == totalDays + 1{
            buildingDay += 66
        }
        switch buildingDay{
        case 1:
            generateDay1()
        case 2:
            generateDay2()
        case 3:
            generateDay3()
        case 4:
            generateDay4()
        default:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                firestoreCommands.generateProgramDetails(self.currentProgramID, self.totalDays)
                firestoreCommands.writeProgramToFirestore(self.day1CompleteWorkout, 1, self.currentProgramID)
                firestoreCommands.writeProgramToFirestore(self.day2CompleteWorkout, 2, self.currentProgramID)
                firestoreCommands.writeProgramToFirestore(self.day3CompleteWorkout, 3, self.currentProgramID)
                firestoreCommands.writeProgramToFirestore(self.day4CompleteWorkout, 4, self.currentProgramID)
            }
            
        }
    }
    
    func generateDay1(){
        let firestoreCommands = FirestoreCommands(userInfo: userInfo)
        print("making day 1 -----")
        switch selectedSplit{
        case "FULL":
            let fullDayBuilder = FullDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 1)
            day1Exercises = fullDayBuilder.generateProgram(1)
        case "PPL":
            let PPLDayBuilder = PPLDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 1)
            day1Exercises = PPLDayBuilder.generateProgram(1)
        case "UL":
            let ULDayBuilder = ULDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 1)
            day1Exercises = ULDayBuilder.generateProgram(1)
        default:
            print("error Day 1")
        }
        let setRepGenerator = SetRepGeneration(userInfo: userInfo!, firestoreCommands: firestoreCommands, builtWorkout: day1Exercises)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.day1CompleteWorkout = setRepGenerator.completeWorkout
        }
        buildingDay += 1
        dayProgramGen()
        
    }
    func generateDay2(){
        let firestoreCommands = FirestoreCommands(userInfo: userInfo)
        print("making day 2 -----")
        switch selectedSplit{
        case "FULL":
            let fullDayBuilder = FullDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 2)
            fullDayBuilder.removeDuplicate(day1Exercises)
            day2Exercises = fullDayBuilder.generateProgram(2)
        case "PPL":
            
            let PPLDayBuilder = PPLDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 2)
            PPLDayBuilder.removeDuplicate(day1Exercises)
            day2Exercises = PPLDayBuilder.generateProgram(2)
        case "UL":
            let ULDayBuilder = ULDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 2)
            ULDayBuilder.removeDuplicate(day1Exercises)
            day2Exercises = ULDayBuilder.generateProgram(2)
        default:
            print("error Day 2")
        }
        let setRepGenerator = SetRepGeneration(userInfo: userInfo!, firestoreCommands: firestoreCommands, builtWorkout: day2Exercises)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.day2CompleteWorkout = setRepGenerator.completeWorkout
        }
        buildingDay += 1
        dayProgramGen()
    }
    func generateDay3(){
        let firestoreCommands = FirestoreCommands(userInfo: userInfo)
        print("making day 3 -----")
        switch selectedSplit{
        case "FULL":
            let fullDayBuilder = FullDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 3)
            fullDayBuilder.removeDuplicate(day1Exercises + day2Exercises)
            day3Exercises = fullDayBuilder.generateProgram(3)
        case "PPL":
            let PPLDayBuilder = PPLDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 3)
            PPLDayBuilder.removeDuplicate(day1Exercises + day2Exercises)
            day3Exercises = PPLDayBuilder.generateProgram(3)
        case "UL":
            let ULDayBuilder = ULDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 3)
            ULDayBuilder.removeDuplicate(day1Exercises + day2Exercises)
            day3Exercises = ULDayBuilder.generateProgram(3)
        default:
            print("error Day3")
        }
        let setRepGenerator = SetRepGeneration(userInfo: userInfo!, firestoreCommands: firestoreCommands, builtWorkout: day3Exercises)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.day3CompleteWorkout = setRepGenerator.completeWorkout
        }
        buildingDay += 1
        dayProgramGen()
    }
    func generateDay4(){
        print("making day 4-----")
        let firestoreCommands = FirestoreCommands(userInfo: userInfo)
        switch selectedSplit{
        case "FULL":
            let fullDayBuilder = FullDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 4)
            fullDayBuilder.removeDuplicate(day1Exercises + day2Exercises + day3Exercises)
            day4Exercises = fullDayBuilder.generateProgram(4)
        case "PPL":
            let circuitDayBuilder = CircuitDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 4)
            day4Exercises = circuitDayBuilder.generateProgram()
        case "UL":
            let ULDayBuilder = ULDayBuilder(plyoExercises: plyoExercises, upperExercises: upperExercises, lowerExercises: lowerExercises, coreExercises: coreExercises, armsExercises: armsExercises, userInfo: userInfo!, blocks: blocks, buildingDay: 4)
            ULDayBuilder.removeDuplicate(day1Exercises + day2Exercises + day3Exercises)
            day4Exercises = ULDayBuilder.generateProgram(4)
        default:
            print("error Day3")
        }
        let setRepGenerator = SetRepGeneration(userInfo: userInfo!, firestoreCommands: firestoreCommands, builtWorkout: day4Exercises)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.day4CompleteWorkout = setRepGenerator.completeWorkout
        }
        buildingDay += 1
    }
    
    //    func generateDay1(){
    //        //        print("Day 1 Generation")
    //        done1Reading = false
    //        let day = 1
    //        let pathOutline = ProgramOutline.getOutline(totalDays, day, blockCounters[day-1])
    //        if pathOutline == ["66"]{
    //            for i in 0...self.day1Exercises.count-1{
    //                self.writeExercise(i , day, self.day1Exercises[i], self.day1Blocks[i])
    //            }
    //        }else{
    //            let totalExercises = pathOutline.count - 1
    //            let skillLevel = detSkillLevel(pathOutline[exerciseCounters[day-1]])
    //            temp1Exercises.removeAll()
    //            readDB(day, pathOutline[exerciseCounters[day-1]], skillLevel)
    //
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
    //                if let name = self.temp1Exercises.randomElement(){
    //                    if self.checkDuplicate(name , self.day1Exercises) == false{
    //                        self.day1Exercises.append(name)
    //                    }else{
    //                        self.exerciseCounters[day-1] -= 1
    //                        self.generateDay1()
    //                    }
    //                }
    //                self.done1Reading = true
    //
    //                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
    //                    if self.exerciseCounters[day-1] == totalExercises{
    //                        self.exerciseCounters[day-1] = 0
    //                        self.day1Blocks.append(self.blockCounters[day-1])
    //                        self.blockCounters[day-1] += 1
    //                        self.generateDay1()
    //                    }else if self.done1Reading == true && self.exerciseCounters[day-1] != totalExercises{
    //                        self.exerciseCounters[day-1] += 1
    //                        self.day1Blocks.append(self.blockCounters[day-1])
    //                        self.generateDay1()
    //                    }
    //                }
    //            }
    //        }
    //    }
    //    func generateDay2(){
    //        //        print("Day 2 Generation")
    //        done2Reading = false
    //        let day = 2
    //        let pathOutline = ProgramOutline.getOutline(totalDays, day, blockCounters[day-1])
    //        if pathOutline == ["66"]{
    //            for i in 0...self.day2Exercises.count-1{
    //                self.writeExercise(i , day, self.day2Exercises[i], self.day2Blocks[i])
    //            }
    //
    //        }else {
    //            let totalExercises = pathOutline.count - 1
    //            let skillLevel = detSkillLevel(pathOutline[exerciseCounters[day-1]])
    //            temp2Exercises.removeAll()
    //            readDB(day, pathOutline[exerciseCounters[day-1]], skillLevel)
    //
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
    //                if let name = self.temp2Exercises.randomElement(){
    //                    if self.checkDuplicate(name , self.day2Exercises) == false{
    //                        self.day2Exercises.append(name)
    //                    }else{
    //                        self.exerciseCounters[day-1] -= 1
    //                        self.generateDay2()
    //                    }
    //                }
    //                self.done2Reading = true
    //
    //                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
    //                    if self.exerciseCounters[day-1] == totalExercises{
    //                        self.exerciseCounters[day-1] = 0
    //                        self.day2Blocks.append(self.blockCounters[day-1])
    //                        self.blockCounters[day-1] += 1
    //                        self.generateDay2()
    //                    }else if self.done2Reading == true && self.exerciseCounters[day-1] != totalExercises{
    //                        self.exerciseCounters[day-1] += 1
    //                        self.day2Blocks.append(self.blockCounters[day-1])
    //                        self.generateDay2()
    //                    }
    //                }
    //            }
    //        }
    //    }
    //    func generateDay3(){
    //        //        print("Day 3 Generation")
    //        done3Reading = false
    //        let day = 3
    //        let pathOutline = ProgramOutline.getOutline(totalDays, day, blockCounters[day-1])
    //        if pathOutline == ["66"]{
    //            for i in 0...self.day3Exercises.count-1{
    //                self.writeExercise(i , day, self.day3Exercises[i], self.day3Blocks[i])
    //            }
    //
    //        }else {
    //            let totalExercises = pathOutline.count - 1
    //            let skillLevel = detSkillLevel(pathOutline[exerciseCounters[day-1]])
    //            temp3Exercises.removeAll()
    //            readDB(day, pathOutline[exerciseCounters[day-1]], skillLevel)
    //
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
    //                if let name = self.temp3Exercises.randomElement(){
    //                    if self.checkDuplicate(name , self.day3Exercises) == false{
    //                        self.day3Exercises.append(name)
    //                    }else{
    //                        self.exerciseCounters[day-1] -= 1
    //                        self.generateDay3()
    //                    }
    //                }
    //                self.done3Reading = true
    //
    //                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
    //                    if self.exerciseCounters[day-1] == totalExercises{
    //                        self.exerciseCounters[day-1] = 0
    //                        self.day3Blocks.append(self.blockCounters[day-1])
    //                        self.blockCounters[day-1] += 1
    //                        self.generateDay3()
    //                    }else if self.done3Reading == true && self.exerciseCounters[day-1] != totalExercises{
    //                        self.exerciseCounters[day-1] += 1
    //                        self.day3Blocks.append(self.blockCounters[day-1])
    //                        self.generateDay3()
    //                    }
    //                }
    //            }
    //        }
    //    }
    //    func generateDay4(){
    //        //        print("Day 4 Generation")
    //        done3Reading = false
    //        let day = 4
    //        let pathOutline = ProgramOutline.getOutline(totalDays, day, blockCounters[day-1])
    //        if pathOutline == ["66"]{
    //            for i in 0...self.day4Exercises.count-1{
    //                self.writeExercise(i , day, self.day4Exercises[i], self.day4Blocks[i])
    //            }
    //        }else{
    //            let totalExercises = pathOutline.count - 1
    //            let skillLevel = detSkillLevel(pathOutline[exerciseCounters[day-1]])
    //            temp4Exercises.removeAll()
    //            readDB(day, pathOutline[exerciseCounters[day-1]], skillLevel)
    //
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
    //                if let name = self.temp4Exercises.randomElement(){
    //                    if self.checkDuplicate(name , self.day4Exercises) == false{
    //                        self.day4Exercises.append(name)
    //                    }else{
    //                        self.exerciseCounters[day-1] -= 1
    //                        self.generateDay4()
    //                    }
    //                }
    //                self.done4Reading = true
    //
    //                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
    //                    if self.exerciseCounters[day-1] == totalExercises{
    //                        self.exerciseCounters[day-1] = 0
    //                        self.day4Blocks.append(self.blockCounters[day-1])
    //                        self.blockCounters[day-1] += 1
    //                        self.generateDay4()
    //                    }else if self.done4Reading == true && self.exerciseCounters[day-1] != totalExercises{
    //                        self.exerciseCounters[day-1] += 1
    //                        self.day4Blocks.append(self.blockCounters[day-1])
    //                        self.generateDay4()
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    
    
    
    func checkDuplicate(_ newExercise: String, _ dayExercises: [String]) -> Bool{
        for name in dayExercises{
            if newExercise == name{
                return true
            }
        }
        return false
    }
    
    
    
    
    func readDB(_ day: Int, _ path: String, _ skillLevel: Int){
        let docRef = db.collection(path).whereField("level", isLessThanOrEqualTo: skillLevel)
        
        if day == 1{
            docRef.getDocuments { collection, err in
                if let err = err{
                    print(err)
                }else{
                    for document in collection!.documents{
                        self.temp1Exercises.append(document.reference.path)
                    }
                }
            }
        }else if day == 2{
            docRef.getDocuments { collection, err in
                if let err = err{
                    print(err)
                }else{
                    for document in collection!.documents{
                        self.temp2Exercises.append(document.reference.path)
                    }
                }
            }
        }else if day == 3{
            docRef.getDocuments { collection, err in
                if let err = err{
                    print(err)
                }else{
                    for document in collection!.documents{
                        self.temp3Exercises.append(document.reference.path)
                    }
                }
            }
        }else if day == 4{
            docRef.getDocuments { collection, err in
                if let err = err{
                    print(err)
                }else{
                    for document in collection!.documents{
                        self.temp4Exercises.append(document.reference.path)
                    }
                }
            }
        }
        
    }
    
    func detSkillLevel(_ path: String) -> Int{
        if path == dK.category.plyo || path == dK.category.plyo || path == dK.category.plyo{
            return userInfo!.plyoLevel
        }else if path == dK.category.upper || path == dK.category.upper{
            return userInfo!.upperLevel
        }else if path == dK.category.lower || path == dK.category.lower{
            return userInfo!.lowerLevel
        }else if path == dK.category.core || path == dK.category.core{
            return userInfo!.coreLevel
        }else if path == dK.category.arms || path == dK.category.arms || path == dK.category.arms{
            return userInfo!.armsLevel
        }
        return 0
    }
}






extension ProgramMaker{
    
    //    func generateProgramDetails(){
    //        //Sets nextProgramMade in Previous program to true and readyForNext to false
    //        db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(currentProgramID)").document("programDetails").setData(["readyForNext" : false, "nextProgramMade" : true], merge: true)
    //
    //        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(currentProgramID + 1)").document("programDetails")
    //        for day in 1...totalDays{
    //            docRef.setData(["day\(day)Completion" : 0], merge: true)
    //        }
    //        docRef.setData(["totalDays" : totalDays, "currentDay" : 1, "week" : 0, "readyForNext" : false, "nextProgramMade": false], merge: true)
    //
    //    }
    //    func writeExercise(_ order: Int, _ day: Int, _ path: String, _ block: Int) {
    //
    //        let docRef = db.document(path)
    //
    //        docRef.getDocument() { (document, err) in
    //            if let err = err {
    //                print(err)
    //            }else{
    //                if let document = document{
    //                    self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("programInventory").document("programs").collection("program\(self.currentProgramID + 1)").document("day\(day)").collection("exercises").document("\(document.documentID)").setData([
    //                        "name" : document["name"] as! String,
    //                        "skillTree" : document["skillTree"] as! [String],
    //                        "reps" : ProgramOutline.getReps(self.userInfo!.trainingType),
    //                        "sets" : 3,
    //                        "order" : order,
    //                        "block" : block])
    //                }
    //            }
    //
    //        }
    //    }
    
    
    
    func findMonth()-> String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return(nameOfMonth)
    }
}



// MARK: Gets User Data
extension ProgramMaker{
    func getUserInfo(){
        let tabBar = tabBarController as! TabBarViewController
        totalDays = tabBar.totalDays
        currentProgramID = tabBar.programID
        let docRef = db.collection(K.s.users).document(K.db.userAuth)
        docRef.getDocument { document, err in
            if let err = err{
                print(err)
            }else{
                if let document = document{
                    self.levels[K.s.skillTree.trainingType] = document[K.s.skillTree.trainingType] as! Int
                    
                }
            }
        }
        let skillTreeRef = db.collection(K.s.users).document(K.db.userAuth).collection(K.s.skillTree.skillTree)
        
        skillTreeRef.getDocuments { collection, error in
            if let error = error{
                print(error)
            }else{
                if let collection = collection{
                    for document in collection.documents{
                        self.levels[document.documentID] = document["level"] as! Int
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.userInfo = UserInfo(
                playerLevel: self.levels[K.s.skillTree.player]!,
                trainingType: self.levels[K.s.skillTree.trainingType]!,
                upperLevel: self.levels[K.s.skillTree.upper]!,
                lowerLevel: self.levels[K.s.skillTree.lower]!,
                plyoLevel: self.levels[K.s.skillTree.plyo]!,
                coreLevel: self.levels[K.s.skillTree.core]!,
                armsLevel: self.levels[K.s.skillTree.arms]!)
            
            self.retrievePossibleExercises()
        }
    }
    func retrievePossibleExercises(){
        if let userInfo = userInfo{
            let firestoreCommands = FirestoreCommands(userInfo: userInfo)
            firestoreCommands.fetchPossibleExercises("plyo", userInfo.plyoLevel) { exercises in
                self.plyoExercises = exercises
            }
            firestoreCommands.fetchPossibleExercises("upper", userInfo.upperLevel) { exercises in
                self.upperExercises = exercises
            }
            firestoreCommands.fetchPossibleExercises("lower", userInfo.lowerLevel) { exercises in
                self.lowerExercises = exercises
            }
            firestoreCommands.fetchPossibleExercises("core", userInfo.coreLevel) { exercises in
                self.coreExercises = exercises
            }
            firestoreCommands.fetchPossibleExercises("arms", userInfo.armsLevel) { exercises in
                self.armsExercises = exercises
            }
            finishedButton.isEnabled = true
            
        }
    }
    
    
}
