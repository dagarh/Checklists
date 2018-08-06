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
        /*
         /* If there was no segue then we could have done like this by creating the instance of AddItemViewController by our own and then setting the delegate, BUT since we have a seque hence we would make use of the instance, of AddItemViewController, which is created for us by segue. */
         
         let addItemVC = storyboard?.instantiateViewController(withIdentifier: "addItemVC") as! AddItemViewController
         addItemVC.delegate = self
         
         /* we could have used "present" method here to present AddItemViewController but since we are making use of navigation controller and navigation bar is just because of this navigation controller, hence use navigationController provided method only. If we try to present controller with the help of 'present' method then we would not get navigation bar above in view controller.  */
         navigationController?.pushViewController(addItemVC, animated: true)
         */

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
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem) {
        
        let newRowIndex = checklistItems.itemArray.count
        checklistItems.append(item)
        
        // There could be multiple indexPaths so that you can insert multiple rows together.
        let indexPaths = [IndexPath(row: newRowIndex, section: 0)]
        
        /* This would call cellForRowAt method and that will fetch the data from array for displaying the corresponding cell. This is a much better way than reloading the whole tableview. */
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }
    
    
}

extension ChecklistViewController {
    
    //MARK: - Table View Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        // cell.textLabel?.text = "Himanshu"
        
        /* you can create your own label for customised cells and use them like below using tag. 2 elements could have same tag on 2 diff-diff views.
         
         Instead we could have created separate class for the customised cell and then create outlets of all the UIelements. and then access already created instances from those outlets. This is how we do when there are more UI elements in a cell. */
        
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
        
        // there could be multiple indexPath if you want to delete more rows. This would inturn call cellForRowAt method. You could say reload whole tableView but that would be in-efficient.
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}
