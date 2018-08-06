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
        
        /* There are 2 ways through which you can set up an action for the events on UIElements. One way is through the delegates and another way is through the UIControl events. Now while using UIControl events, there are 2 ways. One is to create the action method for particular event from connection inspector by pressing ctrl and then drag. Another way is this which I did below i.e using "addTarget" method. Target could be nil, in that case event will look for its action method using the "Responder chain" hierarchy. If it does not find that action method then that event would be ignored by an iOS. */
        textField.addTarget(nil, action: #selector(donePressed), for: UIControlEvents.editingDidEndOnExit)
        /* editingDidEndOnExit --> even if you have a blank action method corresponding to this event, it would end session for the textfield, which is the first responder. Because its job is to end session of textField and hence it means textField would no longer to the first responder now.  */
        
    }
    
    /* Loading would happen first, before appearance. So order of methods called would be viewDidLoad(), viewWillAppear() and then viewDidAppear() would be called in this sequence. These 3 methods at starting would be called when we push/present the view . And when we pop/dismiss the view at that time viewWillDisappear() and then viewDidDisappear() would be called.   */
    
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
        
        /* It is equivalent of dismiss method but while making use of navigation controller then use its own methods instead of using dismiss method because navigation bar is because of this navigation controller hence that navigation bar would not get dismissed by dismiss method. */
    }
    
    /* This would be called from UIBarButtonItem and also from UITextField, that's why "Any" is mandatory here. */
    @IBAction func donePressed(_ sender: Any) {
        print(type(of: sender))
        delegate?.addItemViewController(self, didFinishEditing: ChecklistItem(text: textField.text!, done: false))
    }
    
    // MARK: - TableView Delegate Method
    
    /* This would be called just before didSelectRowAt but it is returning nil, it means that row can no more be selected and hence didSelectRowAt would never be called. This is a hack which you can use if you don't want your cell to be selected. */
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
   
}

extension AddItemViewController : UITextFieldDelegate {
    
    // MARK: - TextField Delegate Methods
    
    /* We could have used "Editing Changed" UIControl event and then create action method of that here. Through that way we could have got new updated text there directly and then we just had to check for isEmpty but it is ok to know this way too. */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // This would be called before changing the content. That's why we are able to take the oldText here.
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)

        let newText = oldText.replacingCharacters(in: stringRange!, with: string)

        if newText.isEmpty {
            doneBarButton.isEnabled = false
        }else{
            doneBarButton.isEnabled = true
        }
        return true
    }
/*
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // backspace
        if string.isEmpty {
            return true
        }
        let lc = string.lowercased()
        textField.insertText(lc)
        return false
    }
*/
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // This would be called after textFieldShouldBeginEditing and only if textFieldShouldBeginEditing returns true.
        doneBarButton.isEnabled = false
        print("Did Begin Editing")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        /* If you return false here then you would never be able to select textfield to enter text in it. It is the same hack which we performed above to disable the selection of tableview cell. */
        print("Should Begin Editing!!!")
        return true
    }
    
    /*
     /* This could be done through editingDidEndOnExit control event. You can have a look at other control events at this link: https://developer.apple.com/documentation/uikit/uicontrol/event */
     
     /*
     "editingDidEndOnExit" control event --> this event gets triggered when return key is pressed and "textFieldShouldReturn" method also gets called. So we can do things at any of these 2 places.
     
     When return key is pressed, we want to achieve the same thing which "donePressed" method is doing above. So instead of creating below method separately and doing same thing again, we can make use of "editingDidEndOnExit" control event. If we wanted to do separate things then definitely could have implemented this method. So right click on textfield and connect "editingDidEndOnExit control event" to "donePressed" method.  */
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     textField.resignFirstResponder()
     print(textField.text!)
     return true
     }
     */
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Whenever text field losses focus, this has to be called. Before this textFieldShouldEndEditing would be called. Reason could be : endEditing on textfield OR resigningFirstResponder by textfield or by view or contanier which contains textfield OR popping out the view controller which contains text field.
    }
    
}
