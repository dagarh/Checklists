//
//  Item.swift
//  Checklists
//
//  Created by Himanshu Dagar on 05/08/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import Foundation

class ChecklistItem {
    
    var text : String
    var checked : Bool
    
    init(text: String, done: Bool) {
        self.text = text
        self.checked = done
    }
    
    func toggleChecked() {
        self.checked = !self.checked
    }
    
}
