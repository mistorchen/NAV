//
//  WorkoutSplits.swift
//  NAV
//
//  Created by Alex Chen on 7/5/23.
//

import Foundation

struct WorkoutSplits{
    static func getSplitCode(_ totalDays: Int, _ split: String) -> [String]{
        switch totalDays{
        case 1:
            return ["FULL"]
        case 2:
            switch split{
            case "FULL":
                return ["FULL", "FULL2"]
            case "UPLOW":
                return ["UPPER", "LOWER"]
            default:
                return ["error"]
            }
        case 3:
            switch split{
            case "FULL":
                return ["FULL", "FULL2", "FULL"]
            case "UPLOW":
                return ["UPPER", "LOWER", "FULL"]
            case "PPL":
                return ["PUSH", "PULL", "LEGS"]
            default:
                return ["error"]
            }
        case 4:
            switch split{
            case "FULL":
                return ["FULL", "FULL2", "FULL", "FULL2"]
            case "UPLOW":
                return ["UPPER", "LOWER", "UPPER", "LOWER"]
            case "PPL":
                return ["PUSH", "PULL", "LEGS", "FULL"]
            default:
                return ["error"]
            }
        case 5:
            switch split{
            case "FULL":
                return ["FULL", "FULL2", "FULL", "FULL2", "CARDIO"]
            case "UPLOW":
                return ["UPPER", "LOWER", "UPPER2", "LOWER2", "CARDIO"]
            case "PPL":
                return ["PUSH", "PULL", "LEGS", "PUSH2", "PULL2"]
            default:
                return ["error"]
            }
        case 6:
            switch split{
            case "FULL":
                return ["FULL", "FULL2", "FULL", "FULL2", "FULL", "FULL2"]
            case "UPLOW":
                return ["UPPER", "LOWER", "CARDIO", "UPPER2", "LOWER2", "CARDIO2"]
            case "PPL":
                return ["PUSH", "PULL", "LEGS", "PUSH2", "PULL2", "LEGS2"]
            default:
                return ["error"]
            }
        default:
            return ["error"]
        }
    }
}
