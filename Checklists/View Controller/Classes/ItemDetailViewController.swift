//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Himanshu Dagar on 05/08/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit


class ItemDetailViewController: UITableViewController {

    var itemToEdit : ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        // For individual-2 UI elements we should always make separate methods.
        configureTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    /* weak means it is not increasing the reference counting towards the delegate object. */
    weak var delegate : ItemDetailViewControllerDelegate?
    
    //MARK: - Outlets Connection
    
    /* Since we are using static cells, so we can make outlet connections in this same class, if it was dynamic cell then we could have used its own custom cell class. */
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //MARK: - Action Methods Connection
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    /* This would be called when pressing "+" or "Return" key of keyboard. */
    @IBAction func donePressed(_ sender: Any) {
        print(type(of: sender))
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: itemToEdit)
        }else {
            delegate?.itemDetailViewController(self, didFinishAdding: ChecklistItem(text: textField.text!, done: false))
        }
    }
    
    // MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK: - Text Field UIControl Method
    @IBAction func editingChanged(_ sender: UITextField) {
        
        let text = sender.text!
        if text.isEmpty {
            doneBarButton.isEnabled = false
        }else{
            doneBarButton.isEnabled = true
        }
    }
    
    //MARK: - Configuration Methods
    
    func configureTextField() {
        textField.delegate = self
        textField.addTarget(nil, action: #selector(donePressed), for: UIControlEvents.editingDidEndOnExit)
        if let item = itemToEdit {
            
            // This is the title property coming from UIViewController
            title = "Edit Item"
            
            textField.text = item.text
            textField.placeholder = "Edit an Item"
            doneBarButton.isEnabled = true
        } else {
            textField.placeholder = "Add an Item"
            doneBarButton.isEnabled = false
        }
    }
   
}

extension ItemDetailViewController : UITextFieldDelegate {
    // MARK: - TextField Delegate Methods

    // See the "editingChanged" UIControl method above, regarding textField.
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // This would be called after textFieldShouldBeginEditing and only if textFieldShouldBeginEditing returns true.
        print("Did Begin Editing")
    }
    
}
