//
//  PhoneBookViewController.swift
//  iPhoneBook
//
//  Created by Megha Kulkarni on 09/10/19.
//  Copyright © 2019 Megha Kulkarni. All rights reserved.
//

import UIKit
import CoreData

class PhoneBookViewController: UITableViewController {
    
    var phoneBook : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Contact", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Contact", style: .default) { (action) in
            print("success!")
        }
        alert.addAction(action)
    }
    
    
    func fetch () {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        
        do {
            phoneBook = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Cannot fetch contact. \(error)")
        }
    }
    
    func save(name: String, phoneNumber:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let objectContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: objectContext) else {return}
        let contact = NSManagedObject(entity: entity, insertInto: objectContext)
        contact.setValue(name, forKey: "name")
        contact.setValue(phoneNumber, forKey: "phoneNumber")
        if objectContext.hasChanges {
            print("name is \(name)")
        }
        do {
            try objectContext.save()
            self.phoneBook.append(contact)
        } catch let error as NSError{
            print("Cannot save contact. \(error)")
        }
    }

    func update(indexPath: IndexPath, name: String, phoneNumber: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let objectContext = appDelegate.persistentContainer.viewContext
        let contact = phoneBook[indexPath.row]
        
        contact.setValue(name, forKey: "name")
        contact.setValue(phoneNumber, forKey: "phoneNumber")
        do {
            try objectContext.save()
            phoneBook[indexPath.row] = contact
        } catch let error as NSError {
            print("cannot update contact list \(error)")
        }
    }
    
    func delete(_ contact: NSManagedObject, at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let objectContext = appDelegate.persistentContainer.viewContext
        objectContext.delete(contact)
        phoneBook.remove(at: indexPath.row)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneBook.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iPhoneBookCell", for: indexPath)
        
        let contact = phoneBook[indexPath.row]
        cell.textLabel?.text = contact.value(forKey: "name") as! String
        cell.detailTextLabel?.text = contact.value(forKey: "phoneNumber") as! String
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContactDetail" {
            guard let navVar = segue.destination as? UINavigationController else {return}
            guard let VC = navVar.topViewController as? ContactDetailsViewController else {return}
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let contact = phoneBook[indexPath.row]
            VC.contact = contact
            VC.indexPath = indexPath
        }
    }
    
    
    @IBAction func unwindToPhoneBook(segue: UIStoryboardSegue) {
        
        if let  VC = segue.source as? AddContactsViewController {
            
            guard let name = VC.nameTextField.text else {return}
            guard let phoneNumber = VC.phoneNumberTextField.text else {return}
            print( "stage1")
            if name != "" && phoneNumber != "" {
                if let indexPath = VC.indexPathForContact {
                    update(indexPath: indexPath, name: name, phoneNumber: phoneNumber)
                } else {
                    save(name: name, phoneNumber: phoneNumber)
                }
            }
            tableView.reloadData()
        } else if let VC = segue.source as? ContactDetailsViewController {
            if VC.isDeleted {
                guard let indexPath: IndexPath = VC.indexPath else { return }
                let contact = phoneBook[indexPath.row]
                delete(contact, at: indexPath)
                tableView.reloadData()
            }
        }
    }

}
