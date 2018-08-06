//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Himanshu Dagar on 05/08/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit


class AddItemViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        textField.delegate = self
        
        textField.addTarget(nil, action: #selector(donePressed), for: UIControlEvents.editingDidEndOnExit)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    /* weak means it is not increasing the reference counting towards the delegate object. */
    weak var delegate : AddItemViewControllerDelegate?
    
    //MARK: - Outlets Connection
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //MARK: - Action Methods Connection
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        print(type(of: sender))
        delegate?.addItemViewController(self, didFinishEditing: ChecklistItem(text: textField.text!, done: false))
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
   
}

extension AddItemViewController : UITextFieldDelegate {
    // MARK: - TextField Delegate Methods

    // See the "editingChanged" UIControl method above, regarding textField.
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // This would be called after textFieldShouldBeginEditing and only if textFieldShouldBeginEditing returns true.
        doneBarButton.isEnabled = false
        print("Did Begin Editing")
    }
    
}
