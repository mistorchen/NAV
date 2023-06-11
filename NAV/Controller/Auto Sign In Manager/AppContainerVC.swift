//
//  AppContainerVC.swift
//  NAV
//
//  Created by Alex Chen on 3/16/23.
//

import Foundation
import UIKit

class AppContainerVC: UIViewController{
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            SignInManager.shared.appContainer = self
            SignInManager.shared.showApp()
        }

        
    }
}
