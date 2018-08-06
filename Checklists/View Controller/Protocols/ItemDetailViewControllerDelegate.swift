//
//  ItemDetailViewControllerDelegate.swift
//  Checklists
//
//  Created by Himanshu Dagar on 05/08/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import Foundation

// colon class means this can only be conformed by classes, not by enums and struts.
protocol ItemDetailViewControllerDelegate : class {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}
