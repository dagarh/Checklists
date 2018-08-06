//
//  Item.swift
//  Checklists
//
//  Created by Himanshu Dagar on 05/08/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import Foundation

/* NSObject class inherits from Equatable protocol. So indirectly we are making our "ChecklistItem" objects equatable by value, not by reference. Or this class can conform to Equatable protocol directly and then provide our custom implementation of "==" .  */
class ChecklistItem : NSObject {
    
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
