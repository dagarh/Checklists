//
//  ChecklistItems.swift
//  Checklists
//
//  Created by Himanshu Dagar on 05/08/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import Foundation

class ChecklistItems {
        
    var itemArray = [ChecklistItem]()

    /*
     This only needs to be called when you are fetching persisted data from db.
     */
     func fetchDataFromDB() {
     }
    
    func append(_ item: ChecklistItem){
        itemArray.append(item)
    }
    
    func remove(at index: Int) {
        itemArray.remove(at: index)
    }
}
