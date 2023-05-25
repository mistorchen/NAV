//
//  ProgramOutline.swift
//  NAV
//
//  Created by Alex Chen on 3/2/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct ProgramOutline{
    let db = Firestore.firestore()
    struct program1{ // BASIC STARTING PROGRAM
        let exerciseCount = 9//10
        
        let paths : [Int : String] = [
            0 : dK.category.plyo.lower , 1 : dK.category.plyo.lower, 2 : dK.category.plyo.lower,
            3 : dK.category.lower.bilateral , 4 : dK.category.lower.bilateral,
            5 : dK.category.upper.push, 6 : dK.category.upper.pull,
            7 : dK.category.arms.bicep, 8 : dK.category.arms.tricep, 9 : dK.category.arms.shoulders
        ]
        let blocks : [Int : Int] = [
            0 : 1, 1 : 1, 2 : 1,
            3 : 2, 4 : 2,
            5 : 3, 6 : 3,
            7 : 4, 8 : 4, 9 : 4
        ]
        let blockSizes = [3,2,2,3]
    }
//    
//    static func numberOfDays(_ playerLevel: Int) -> Int{ // Should be based on Goal/ Training Type
//        if playerLevel < 50{
//            return 3
//        }else if playerLevel >= 50{
//            return 4
//        }
//        return 3
//    }
    
    static func getBlocks(_ playerLevel: Int) -> Int{ 
        switch playerLevel{
        case 0...25:
            return 3
        case 25...50:
            return [3,4].randomElement()!
        case 50...75:
            return 4
        case _ where playerLevel > 75:
            return [4,5].randomElement()!
        default:
            return 3
        }
    }
    static func getReps(_ trainingType: Int) -> Int{
        switch trainingType{
        case 0:
            return [4,6].randomElement()!
        case 1:
            return [8, 10, 12].randomElement()!
        case 2:
            return [12, 14, 16].randomElement()!
        default:
            return 8
        }
    }
    static func getOutline(_ totalDays: Int, _ day: Int, _ block: Int) -> [String]{
        switch totalDays{
        case 1:
            switch day{
            case 1:
                switch block{
                case 1:
                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
                case 2:
                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
                case 3:
                    return [dK.category.upper.push, dK.category.upper.pull]
                case 4:
                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders]
                default:
                    return ["66"]
                }
            default:
                return ["error: day"]
            }
        case 2:
            switch day{
            case 1:
                switch block{
                case 1:
                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
                case 2:
                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
                case 3:
                    return [dK.category.upper.push, dK.category.upper.pull]
                case 4:
                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders]
                default:
                    return ["66"]
                }
            case 2:
                switch block{
                case 1:
                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
                case 2:
                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
                case 3:
                    return [dK.category.upper.push, dK.category.upper.pull]
                case 4:
                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders]
                default:
                    return ["66"]
                }
            default:
                return ["error: day"]
            }
        case 3:
            switch day{
            case 1:
                switch block{
                case 1:
                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
                case 2:
                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
                case 3:
                    return [dK.category.upper.push, dK.category.upper.pull]
                case 4:
                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders]
                default:
                    return ["66"]
                }
            case 2:
                switch block{
                case 1:
                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
                case 2:
                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
                case 3:
                    return [dK.category.upper.push, dK.category.upper.pull]
                case 4:
                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders]
                default:
                    return ["66"]
                }
            case 3:
                switch block{
                case 1:
                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
                case 2:
                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
                case 3:
                    return [dK.category.upper.push, dK.category.upper.pull]
                case 4:
                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders]
                default:
                    return ["66"]
                }
            default:
                return ["error: day"]
            }
        case 4:
            switch day{
            case 1:
                switch block{
                case 1:
                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
                case 2:
                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
                case 3:
                    return [dK.category.upper.push, dK.category.upper.pull]
                case 4:
                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders]
                default:
                    return ["66"]
                }
            case 2:
                switch block{
                case 1:
                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
                case 2:
                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
                case 3:
                    return [dK.category.upper.push, dK.category.upper.pull]
                case 4:
                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders]
                default:
                    return ["66"]
                }
            case 3:
                switch block{
                case 1:
                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
                case 2:
                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
                case 3:
                    return [dK.category.upper.push, dK.category.upper.pull]
                case 4:
                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders]
                default:
                    return ["66"]
                }
            case 4:
                switch block{
                case 1:
                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
                case 2:
                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
                case 3:
                    return [dK.category.upper.push, dK.category.upper.pull]
                case 4:
                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders]
                default:
                    return ["66"]
                }
            default:
                return ["error: day"]
            }
        default:
            return ["error"]
        }
    }
    static func getCategory(_ totalDays: Int, _ day: Int) -> [String]{
        switch totalDays{
        case 1:
            switch day{
            case 1:
                return ["plyo", "lower", "upper", "core", "arms"]
            default:
                return ["error: day"]
            }
        case 2:
            switch day{
            case 1:
                return ["plyo", "lower", "upper", "core", "arms"]
            case 2:
                return ["plyo", "lower", "upper", "core", "arms"]
            default:
                return ["error: day"]
            }
        case 3:
            switch day{
            case 1:
                return ["plyo", "lower", "upper", "core", "arms"]
            case 2:
                return ["plyo", "lower", "upper", "core", "arms"]
            case 3:
                return ["plyo", "lower", "upper", "core", "arms"]
            default:
                return ["error: day"]
            }
        case 4:
            switch day{
            case 1:
                return ["plyo", "lower", "upper", "core", "arms"]
            case 2:
                return ["plyo", "lower", "upper", "core", "arms"]
            case 3:
                return ["plyo", "lower", "upper", "core", "arms"]
            case 4:
                return ["plyo", "lower", "upper", "core", "arms"]
            default:
                return ["error: day"]
            }
        default:
            return ["error"]
        }
    }
    
    
//
//    static func getPath(_ block: Int, _ day: Int, _ totalDays: Int) -> [String]{
//        switch totalDays{
//        case 1:
//            switch day{
//            case 1:
//                switch block{
//                case 1:
//                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
//                case 2:
//                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
//
//                case 3:
//                    return [dK.category.upper.push, dK.category.upper.pull]
//                case 4:
//                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders, ]
//                default:
//                    return ["error: block"]
//                }
//
//            default:
//                return ["error: day"]
//            }
//        case 2:
//            switch day{
//            case 1:
//                switch block{
//                case 1:
//                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
//                case 2:
//                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
//
//                case 3:
//                    return [dK.category.upper.push, dK.category.upper.pull]
//                case 4:
//                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders, ]
//                default:
//                    return ["error: block"]
//
//                }
//            case 2:
//                switch block{
//                case 1:
//                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
//                case 2:
//                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
//
//                case 3:
//                    return [dK.category.upper.push, dK.category.upper.pull]
//                case 4:
//                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders, ]
//                default:
//                    return ["error: block"]
//
//                }
//
//            default:
//                return ["error: day"]
//            }
//        case 3:
//            switch day{
//            case 1:
//                switch block{
//                case 1:
//                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
//                case 2:
//                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
//
//                case 3:
//                    return [dK.category.upper.push, dK.category.upper.pull]
//                case 4:
//                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders, ]
//                default:
//                    return ["error: block"]
//
//                }
//            case 2:
//                switch block{
//                case 1:
//                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
//                case 2:
//                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
//
//                case 3:
//                    return [dK.category.upper.push, dK.category.upper.pull]
//                case 4:
//                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders, ]
//                default:
//                    return ["error: block"]
//
//                }
//
//            case 3:
//                switch block{
//                case 1:
//                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
//                case 2:
//                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
//
//                case 3:
//                    return [dK.category.upper.push, dK.category.upper.pull]
//                case 4:
//                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders, ]
//                default:
//                    return ["error: block"]
//
//                }
//
//            default:
//                return ["error: day"]
//            }
//        case 4:
//            switch day{
//            case 1:
//                switch block{
//                case 1:
//                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
//                case 2:
//                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
//
//                case 3:
//                    return [dK.category.upper.push, dK.category.upper.pull]
//                case 4:
//                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders, ]
//                default:
//                    return ["error: block"]
//
//                }
//            case 2:
//                switch block{
//                case 1:
//                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
//                case 2:
//                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
//
//                case 3:
//                    return [dK.category.upper.push, dK.category.upper.pull]
//                case 4:
//                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders, ]
//                default:
//                    return ["error: block"]
//
//                }
//
//            case 3:
//                switch block{
//                case 1:
//                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
//                case 2:
//                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
//
//                case 3:
//                    return [dK.category.upper.push, dK.category.upper.pull]
//                case 4:
//                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders, ]
//                default:
//                    return ["error: block"]
//
//                }
//            case 4:
//                switch block{
//                case 1:
//                    return [dK.category.plyo.lower, dK.category.plyo.upper, dK.category.plyo.mixed]
//                case 2:
//                    return [dK.category.lower.bilateral, dK.category.lower.unilateral]
//
//                case 3:
//                    return [dK.category.upper.push, dK.category.upper.pull]
//                case 4:
//                    return [dK.category.arms.bicep, dK.category.arms.tricep, dK.category.arms.shoulders, ]
//                default:
//                    return ["error: block"]
//
//                }
//
//            default:
//                return ["error: day"]
//            }
//        default:
//            return ["error: totalDays"]
//
//
//        }
//    }
//
//
//
    
}
