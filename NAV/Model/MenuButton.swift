//
//  MenuButtons.swift
//  NAV
//
//  Created by Alex Chen on 6/6/23.
//

import Foundation

struct MenuButton{
    
    let title: String
    let segueIdentifier: String
    
    init(title: String, segueIdentifier: String) {
        self.title = title
        self.segueIdentifier = segueIdentifier
    }
}
