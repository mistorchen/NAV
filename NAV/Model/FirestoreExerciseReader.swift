//
//  Firestore Exercise Reader.swift
//  NAV
//
//  Created by Alex Chen on 2/14/23.
//

import FirebaseCore
import FirebaseFirestore

struct FireStoreExerciseReader{
    let db = Firestore.firestore()
    
    func getExercises(){
        let docRef = db.collection("exercises").document("Category")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
}


