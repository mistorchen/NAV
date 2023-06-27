//
//  SignInManager.swift
//  NAV
//
//  Created by Alex Chen on 3/16/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseFirestore


class SignInManager{
    let db = Firestore.firestore()
    
    
    // MARK: Sign/Register In
    static let shared = SignInManager()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var appContainer: AppContainerVC!
   
    
    private init() { }
    
    func showApp(){
        var  viewController: UIViewController
        
        if Auth.auth().currentUser == nil{
            viewController = storyboard.instantiateViewController(withIdentifier: "SignInVc")
        }else{
            viewController = storyboard.instantiateViewController(withIdentifier: "TabController")
        }
        
        appContainer.present(viewController, animated: true, completion: nil)
    }
    
    
}

