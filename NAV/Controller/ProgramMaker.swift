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
    
    let selectedTree = [K.s.skillTree.upper, K.s.skillTree.lower, K.s.skillTree.plyo, K.s.skillTree.core, K.s.skillTree.arms]
    
    //Initialize empty Variables
    var user = UserInfo(playerLevel: 0, trainingType: 0, upperLevel: 0, lowerLevel: 0, plyoLevel: 0, coreLevel: 0, armsLevel: 0)
    var totalDays = 3
    var reps = 0
    var levels: [String : Int] = [:]
    
    
    
    var done1Reading = false
    var done2Reading = false
    var done3Reading = false
    var done4Reading = false

    
    var temp1Exercises: [String] = []
    var temp2Exercises: [String] = []
    var temp3Exercises: [String] = []
    var temp4Exercises: [String] = []

    
    var day1Exercises: [String] = []
    var day2Exercises: [String] = []
    var day3Exercises: [String] = []
    var day4Exercises: [String] = []

    
    var day1Blocks: [Int] = []
    var day2Blocks: [Int] = []
    var day3Blocks: [Int] = []
    var day4Blocks: [Int] = []

    
    var exerciseCounters = [0,0,0,0,0]
    var blockCounters = [1,1,1,1,1]

    @IBOutlet weak var numberOfDays: UILabel!
    @IBOutlet weak var dayStepper: UIStepper!
    
    
    override func viewDidLoad() {
        getUserInfo()
        super.viewDidLoad()
        dayStepper.value = 3.0
        numberOfDays.text = "3"
    }
    
    @IBAction func dayStepper(_ sender: UIStepper) {
        
        totalDays = Int(sender.value)
        numberOfDays.text = "\(totalDays)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        dayProgramGen(totalDays)
    }
}

extension ProgramMaker{
    func dayProgramGen(_ totalDays: Int){
        switch totalDays{
        case 1:
            generateDay1()
        case 2:
            generateDay1()
            generateDay2()
        case 3:
            generateDay1()
            generateDay2()
            generateDay3()
        case 4:
            generateDay1()
            generateDay2()
            generateDay3()
            generateDay4()
        default:
            print("error")
        }
        
        
    }
    func generateDay1(){
        //        print("Day 1 Generation")
        done1Reading = false
        let day = 1
        let pathOutline = ProgramOutline.getOutline(totalDays, day, blockCounters[day-1])
        let totalExercises = pathOutline.count-1
        let skillLevel = detSkillTree(pathOutline[exerciseCounters[day-1]])
        temp1Exercises.removeAll()
        readDB(day, pathOutline[exerciseCounters[day-1]], skillLevel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            if let name = self.temp1Exercises.randomElement(){
                if self.checkDuplicate(name , self.day1Exercises) == false{
                    self.day1Exercises.append(name)
                    print("Day 1: \(name)")
                }else{
                    self.exerciseCounters[day-1] -= 1
                    self.generateDay1()
                }
            }
            self.done1Reading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                if pathOutline == ["66"]{
                    for i in 0...self.day1Exercises.count-1{
                        self.writeExercise(i , day, self.day1Exercises[i], self.day1Blocks[i])
                    }
                    print("Day 1 Done!")
                }else if self.exerciseCounters[day-1] == totalExercises{
                    self.exerciseCounters[day-1] = 0
                    self.day1Blocks.append(self.blockCounters[day-1])
                    self.blockCounters[day-1] += 1
                    self.generateDay1()
                }else if self.done1Reading == true && self.exerciseCounters[day-1] != totalExercises{
                    self.exerciseCounters[day-1] += 1
                    self.day1Blocks.append(self.blockCounters[day-1])
                    self.generateDay1()
                }
            }
        }
    }
    func generateDay2(){
        //        print("Day 2 Generation")
        done2Reading = false
        let day = 2
        let pathOutline = ProgramOutline.getOutline(totalDays, day, blockCounters[day-1])
        let totalExercises = pathOutline.count-1
        let skillLevel = detSkillTree(pathOutline[exerciseCounters[day-1]])
        temp2Exercises.removeAll()
        readDB(day, pathOutline[exerciseCounters[day-1]], skillLevel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            if let name = self.temp2Exercises.randomElement(){
                if self.checkDuplicate(name , self.day2Exercises) == false{
                    self.day2Exercises.append(name)
                    print("Day 2: \(name)")
                }else{
                    self.exerciseCounters[day-1] -= 1
                    self.generateDay2()
                }
            }
            self.done2Reading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                if pathOutline == ["66"]{
                    for i in 0...self.day2Exercises.count-1{
                        self.writeExercise(i , day, self.day2Exercises[i], self.day2Blocks[i])
                    }
                    print("Day 2 Done!")
                }else if self.exerciseCounters[day-1] == totalExercises{
                    self.exerciseCounters[day-1] = 0
                    self.day2Blocks.append(self.blockCounters[day-1])
                    self.blockCounters[day-1] += 1
                    self.generateDay2()
                }else if self.done2Reading == true && self.exerciseCounters[day-1] != totalExercises{
                    self.exerciseCounters[day-1] += 1
                    self.day2Blocks.append(self.blockCounters[day-1])
                    self.generateDay2()
                }
            }
        }
    }
    func generateDay3(){
        //        print("Day 3 Generation")
        done3Reading = false
        let day = 3
        let pathOutline = ProgramOutline.getOutline(totalDays, day, blockCounters[day-1])
        let totalExercises = pathOutline.count-1
        let skillLevel = detSkillTree(pathOutline[exerciseCounters[day-1]])
        temp3Exercises.removeAll()
        readDB(day, pathOutline[exerciseCounters[day-1]], skillLevel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            if let name = self.temp3Exercises.randomElement(){
                if self.checkDuplicate(name , self.day3Exercises) == false{
                    self.day3Exercises.append(name)
                    print("Day 3: \(name)")
                }else{
                    self.exerciseCounters[day-1] -= 1
                    self.generateDay3()
                }
            }
            self.done3Reading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                if pathOutline == ["66"]{
                    for i in 0...self.day3Exercises.count-1{
                        self.writeExercise(i , day, self.day3Exercises[i], self.day3Blocks[i])
                    }
                    print("Day 3 Done!")
                }else if self.exerciseCounters[day-1] == totalExercises{
                    self.exerciseCounters[day-1] = 0
                    self.day3Blocks.append(self.blockCounters[day-1])
                    self.blockCounters[day-1] += 1
                    self.generateDay3()
                }else if self.done3Reading == true && self.exerciseCounters[day-1] != totalExercises{
                    self.exerciseCounters[day-1] += 1
                    self.day3Blocks.append(self.blockCounters[day-1])
                    self.generateDay3()
                }
            }
        }
    }
    func generateDay4(){
        //        print("Day 4 Generation")
        done3Reading = false
        let day = 4
        let pathOutline = ProgramOutline.getOutline(totalDays, day, blockCounters[day-1])
        let totalExercises = pathOutline.count-1
        let skillLevel = detSkillTree(pathOutline[exerciseCounters[day-1]])
        temp4Exercises.removeAll()
        readDB(day, pathOutline[exerciseCounters[day-1]], skillLevel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            if let name = self.temp4Exercises.randomElement(){
                if self.checkDuplicate(name , self.day4Exercises) == false{
                    self.day4Exercises.append(name)
                    print("Day 4: \(name)")
                }else{
                    self.exerciseCounters[day-1] -= 1
                    self.generateDay4()
                }
            }
            self.done4Reading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                if pathOutline == ["66"]{
                    for i in 0...self.day4Exercises.count-1{
                        self.writeExercise(i , day, self.day4Exercises[i], self.day4Blocks[i])
                    }
                    print("Day 4 Done!")
                }else if self.exerciseCounters[day-1] == totalExercises{
                    self.exerciseCounters[day-1] = 0
                    self.day4Blocks.append(self.blockCounters[day-1])
                    self.blockCounters[day-1] += 1
                    self.generateDay4()
                }else if self.done4Reading == true && self.exerciseCounters[day-1] != totalExercises{
                    self.exerciseCounters[day-1] += 1
                    self.day4Blocks.append(self.blockCounters[day-1])
                    self.generateDay4()
                }
            }
        }
    }
    
    
    
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
    
    func detSkillTree(_ path: String) -> Int{
        if path == dK.category.plyo.lower || path == dK.category.plyo.upper || path == dK.category.plyo.mixed{
            return user.plyoLevel
        }else if path == dK.category.upper.pull || path == dK.category.upper.push{
            return user.upperLevel
        }else if path == dK.category.lower.bilateral || path == dK.category.lower.unilateral{
            return user.lowerLevel
        }else if path == dK.category.core.dynamic || path == dK.category.core.isometric{
            return user.coreLevel
        }else if path == dK.category.arms.bicep || path == dK.category.arms.tricep || path == dK.category.arms.shoulders{
            return user.armsLevel
        }
        return 0
    }
}






extension ProgramMaker{
    func writeExercise(_ order: Int, _ day: Int, _ path: String, _ block: Int) {

        let docRef = db.document(path)

        docRef.getDocument() { (document, err) in
            if let err = err {
                print(err)
            }else{
                if let document = document{
                    self.db.collection("users").document(Auth.auth().currentUser!.uid).collection(self.findMonth()).document("day\(day)").collection("exercises").document("\(document.documentID)").setData([
                        "name" : document["name"] as! String,
                        "reps" : ProgramOutline.getReps(self.user.trainingType),
                        "sets" : 3,
                        "order" : order,
                        "block" : block

                    ])
                }
            }

        }
    }

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
        let docRef = db.collection(K.s.users).document(K.db.userAuth)
        
        docRef.getDocument { document, err in
            if let err = err{
                print(err)
            }else{
                if let document = document{
                    self.levels[K.s.skillTree.playerLevel] = document[K.s.skillTree.playerLevel] as? Int
                    self.levels[K.s.skillTree.trainingType] = document[K.s.skillTree.trainingType] as? Int

                }
            }
        }
        
        
        for tree in selectedTree{
            let docRef = db.collection(K.s.users).document(K.db.userAuth).collection(K.s.skillTree.skillTree).document(tree)
            
            docRef.getDocument { collection, err in
                if let err = err{
                    print(err)
                }else{
                    
                    if let document = collection{
                        self.levels["\(tree)"] = document["exp"] as? Int
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.user = UserInfo(
                playerLevel: self.levels[K.s.skillTree.playerLevel]!,
                trainingType: self.levels[K.s.skillTree.trainingType]!,
                upperLevel: self.levels[K.s.skillTree.upper]!,
                lowerLevel: self.levels[K.s.skillTree.lower]!,
                plyoLevel: self.levels[K.s.skillTree.plyo]!,
                coreLevel: self.levels[K.s.skillTree.core]!,
                armsLevel: self.levels[K.s.skillTree.arms]!)
                
        }
        
        
    }
}
