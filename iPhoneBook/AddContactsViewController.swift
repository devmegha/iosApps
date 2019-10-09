//
//  AddContactsViewController.swift
//  iPhoneBook
//
//  Created by Megha Kulkarni on 09/10/19.
//  Copyright © 2019 Megha Kulkarni. All rights reserved.
//

import UIKit
import CoreData

class AddContactsViewController: UIViewController{
    
    var titleText = "Add Contact"
    var contact : NSManagedObject? = nil
    var indexPathForContact : IndexPath? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        if let contact = self.contact {
            nameTextField.text = contact.value(forKey: "name") as? String
            phoneNumberTextField.text = contact.value(forKey: "phoneNumber") as? String
        }
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToPhoneBook", sender: self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        nameTextField.text = nil
        phoneNumberTextField.text = nil
        performSegue(withIdentifier: "unwindToPhoneBook", sender: self)
        
    }
}

