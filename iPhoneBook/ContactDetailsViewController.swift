//
//  ContactDetailsViewController.swift
//  iPhoneBook
//
//  Created by Megha Kulkarni on 09/10/19.
//  Copyright © 2019 Megha Kulkarni. All rights reserved.
//

import UIKit
import CoreData

class ContactDetailsViewController: UIViewController {

    
        var contact: NSManagedObject? = nil
        var isDeleted: Bool = false
        var indexPath: IndexPath? = nil

        override func viewDidLoad() {
            super.viewDidLoad()
            nameLabel.text = contact?.value(forKey: "name") as? String
            phoneLabel.text = contact?.value(forKey: "phoneNumber") as? String
        }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        
    performSegue(withIdentifier: "unwindToPhoneBookWithSegue", sender: self)
        
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        isDeleted = true
        performSegue(withIdentifier: "unwindToPhoneBookWithSegue", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            guard let VC = segue.destination as? AddContactsViewController else {return}
            VC.titleText = "Edit Contact"
            VC.contact = contact
            VC.indexPathForContact = self.indexPath!
            
        }
    }
    
}


