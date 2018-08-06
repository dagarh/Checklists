//
//  AddItemViewControllerDelegate.swift
//  Checklists
//
//  Created by Himanshu Dagar on 05/08/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import Foundation

// colon class means this can only be conformed by classes, not by enums and struts.
protocol AddItemViewControllerDelegate : class {
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item:ChecklistItem)
}
