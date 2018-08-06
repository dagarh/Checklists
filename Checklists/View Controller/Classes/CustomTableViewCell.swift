//
//  CustomTableViewCell.swift
//  Checklists
//
//  Created by Himanshu Dagar on 06/08/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // Could have used the textLabel which gets inherited from UITableViewCell but that is not much customisable hence using our own.
    @IBOutlet weak var texttLabel: UILabel!
    
    @IBOutlet weak var checkLabel: UILabel!
    
    

}
