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
    
}
