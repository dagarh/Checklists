//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Himanshu Dagar on 04/08/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    let checklistItems = ChecklistItems()
    
    // This is a failable initialiser.
    required init?(coder aDecoder: NSCoder) {
        /*  This would be called before the viewDidLoad */
        
        // Here before super.init, we would be initializing our stored properties.
        // checklistItems.fetchDataFromDB() // could have called in viewDidLoad()
        /* I commented it because user will add items in a checklist dynamically at run time so no need to fetch dummy data. And we are also not persisting any user's data, so no need of this. */
        
        
        super.init(coder: aDecoder)
        
        // can make use of self now when initialization phase is complete.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //MARK: - Action Methods Connection
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToAddItem", sender: self)
    }
    
    //MARK: - Seque Related Method
    /* This method would get called by performSegue and for any kind of segue, this could be called hence make sure to filter things up. */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddItem" {
            let addItemVC = segue.destination as! AddItemViewController
            addItemVC.delegate = self
        }
        
    }
    
}

extension ChecklistViewController : AddItemViewControllerDelegate {
    
    //MARK: - AddItemViewControllerDelegate Protocol Methods Implementation
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        
        // This will pop AddItemViewController screen.
        /* Since we are sending the reference of "AddItemViewController" here, hence we can not pop it in AddItemViewController. */
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem) {
        
        let newRowIndex = checklistItems.itemArray.count
        checklistItems.append(item)
        
        // There could be multiple indexPaths so that you can insert multiple rows together.
        let indexPaths = [IndexPath(row: newRowIndex, section: 0)]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        /* Since we are sending the reference of "AddItemViewController" here, hence we can not pop it in AddItemViewController. */
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension ChecklistViewController {
    
    //MARK: - Table View Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklistItems.itemArray[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
        
    }
    
    //MARK: - Some Configure Methods
    func configureText(for cell: UITableViewCell,with item: ChecklistItem) {
        let label = cell.contentView.viewWithTag(1000) as! UILabel // better to use as? but here we know that it is a label.
        label.text = item.text
    }
    
    func configureCheckmark(for cell: UITableViewCell,with item: ChecklistItem) {
        cell.accessoryType = item.checked ? .checkmark : .none
    }
}

extension ChecklistViewController {
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let currentCell = tableView.cellForRow(at: indexPath) {
            let currentItem = checklistItems.itemArray[indexPath.row]
            currentCell.accessoryType = currentItem.checked ? .none : .checkmark
            currentItem.toggleChecked()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /* This method makes the cell swipable and would be called when we tap on delete red button. */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklistItems.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}
