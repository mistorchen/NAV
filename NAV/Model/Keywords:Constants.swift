//
//  Keywords:Constants.swift
//  NAV
//
//  Created by Alex Chen on 4/14/23.
//

import Foundation
import FirebaseAuth

struct K{
    
    struct s{//shortcut
        struct skillTree{
            static let skillTree = "skillTree"
            static let lower = "lower"
            static let upper = "upper"
            static let plyo = "plyo"
            static let core = "core"
            static let arms = "arms"
            static let playerLevel = "playerLevel"
            static let trainingType = "trainingType"

            
        }
        static let users = "users"

    }
    
    struct db{//database
        
        static let userAuth = Auth.auth().currentUser!.uid

    }
    
    struct color{
        static let beige = UIColor(red: CGFloat(216.0/255.0), green: CGFloat(196.0/255.0), blue: CGFloat(182.0/255.0), alpha: 1)
        static let winter = UIColor(red: CGFloat(245.0/255.0), green: CGFloat(239.0/255.0), blue: CGFloat(231.0/255.0), alpha: 1)
        static let blue = UIColor(red: CGFloat(79.0/255.0), green: CGFloat(112.0/255.0), blue: CGFloat(156.0/255.0), alpha: 1)
        static let navy = UIColor(red: CGFloat(33.0/255.0), green: CGFloat(53.0/255.0), blue: CGFloat(85.0/255.0), alpha: 1)
    }
    
}
