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
        
        /* This is specially used to provide the editing functionality for the table view. See the magic when you click this button. :) */
        /*
         In reality you know there is no magic, so read the concept of this special bar button provided by apple here:
         https://developer.apple.com/documentation/uikit/uiviewcontroller/1621471-editbuttonitem?language=objc
         All the editing functionality which is coming is possible because it is calling setEditing(_:animated:) method and that method contains all the code to do things for us.
         */
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        /* For autoresizing follow this link : https://stackoverflow.com/questions/42453459/dynamically-adjust-the-height-of-the-tableview-cell-based-on-content-ios-swift. And don't forget to apply constraints if you want autoresizing of a cell. */
        configureTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    //MARK: - Action Methods Connection
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addItem", sender: self)
    }
    
    //MARK: - Seque Related Method
    /* This method would get called by performSegue and for any kind of segue, this could be called hence make sure to filter things up. */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem" {
            let addItemVC = segue.destination as! ItemDetailViewController
            addItemVC.delegate = self
        } else if segue.identifier == "editItem" {
            let addItemVC = segue.destination as! ItemDetailViewController
            addItemVC.delegate = self
            
            // sender is IndexPath, using this index path you can fetch row also from tableView.
            if let indexPath = sender as? IndexPath {
                /*
                 Always remember that whenever you are sending data forward then don't use UI elements properties directly, instead create some temporary stored property in the receiver class and then use that.
                 
                 addItemVC.textField.text = checklistItems.itemArray[indexPath.row].text
                 */
                addItemVC.itemToEdit = checklistItems.itemArray[indexPath.row]
            }
        }
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        /* This super call is very important otherwise apple editing functionalities would not come. */
        super.setEditing(editing, animated: animated)
        print("Now you can provide your extra functionality here.")
    }
    
}

extension ChecklistViewController : ItemDetailViewControllerDelegate {
    
    //MARK: - AddItemViewControllerDelegate Protocol Methods Implementation
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        
        // This will pop AddItemViewController screen.
        /* Since we are sending the reference of "AddItemViewController" here, hence we can not pop it in AddItemViewController. */
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = checklistItems.itemArray.count
        checklistItems.append(item)
        
        // There could be multiple indexPaths so that you can insert multiple rows together.
        let indexPaths = [IndexPath(row: newRowIndex, section: 0)]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        /* Since we are sending the reference of "AddItemViewController" here, hence we can not pop it in AddItemViewController. */
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        
        if let index = checklistItems.itemArray.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
}

extension ChecklistViewController {
    
    //MARK: - Table View Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as! CustomTableViewCell
        
        configureCell(cell)
        
        let item = checklistItems.itemArray[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: - Some Configure Methods
    func configureCell(_ cell: CustomTableViewCell) {
        cell.accessoryType = .detailDisclosureButton
    }
    
    func configureText(for cell: CustomTableViewCell,with item: ChecklistItem) {
        cell.texttLabel.text = item.text
    }
    
    func configureCheckmark(for cell: CustomTableViewCell,with item: ChecklistItem) {
        cell.checkLabel.text = item.checked ? "✔" : ""
    }
}

extension ChecklistViewController {
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let currentCell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
            let currentItem = checklistItems.itemArray[indexPath.row]
            currentCell.checkLabel.text = currentItem.checked ? "" : "✔"
            currentItem.toggleChecked()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // You do lil bit of stuff here and then call perform seque, which will call prepare for segue method(in this method I will filter my segue from lot of segues using identifier). I could have created accessory action segue from the connection inspector of table view cell which would have called prepare for segue directly but in that case I can't do my own stuff before prepare for segue, hence using this method of UITableViewDelegate.
        
        performSegue(withIdentifier: "editItem", sender: indexPath)
    }
    
    /* This method makes the cell swipable and would be called when we tap on delete red button. */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            checklistItems.remove(at: indexPath.row)
            
            /* It would call datasource methods. Hence deletion of entry from datamodel is necessary before this. */
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        /*
         This method would be called while a particular row gets edited by somemeans or when new row gets added. If this returns false then editing process or adding process would not happen.
         */
        /*
         Since tableView is providing editing functionality directly, so this would also be called when editButtonItem gets clicked, which we set manually through code like this above : self.navigationItem.leftBarButtonItem = editButtonItem
         */
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        /* You can stop the process of moving by returning false here. Please note that this method is important and would be called only when "moveRowAt" is present. This would also be called at starting when showing editing symbols on right hand side but remember only when "moveRowAt" method is present. */
        print("Can Move Row At")
        return true
    }
    
    /* Because of this method, while pressing special Edit BarButtonItem, we are getting special symbols on right right so that we can move cells and hence we can move cells by holding those. When we actually try to change then first canMoveRowAt method would be called and then this method would be called.  */
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Move Row At")
        /* Not forget to update your data model here. */
        
        // This needs to be moved to the destination location.
        let checklistItem : ChecklistItem = checklistItems.itemArray[sourceIndexPath.row]
        
        checklistItems.itemArray.remove(at: sourceIndexPath.row)
        checklistItems.itemArray.insert(checklistItem, at: destinationIndexPath.row)
        
        /* You know that table view has been updated for us automatically by apple when we did the move. */
    }

}

extension ChecklistViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        
    }
    
}
