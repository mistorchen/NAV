//
//  Firestore.swift
//  NAV
//
//  Created by Alex Chen on 4/18/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

struct FS{
    let db = Firestore.firestore()
    
    static func readDatabase() -> [String]{
        readExercises(dK.category.plyo.lower)
    }
    
    
}
