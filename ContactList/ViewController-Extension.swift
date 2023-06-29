//
//  TableExtensionForVC.swift
//  ContactList
//
//  Created by Sange Sherpa on 28/06/2023.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import SnapKit
import RxCocoa
import RxSwift

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return people.count }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 80 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        
        let currentPerson = people[indexPath.row]
        cell.titleLabel.text = currentPerson.name
        cell.metaLabel.text = currentPerson.phone
        cell.snLabel.text = "\(indexPath.row)"
        
        try! realm.write {
            for contact in people {
                realm.add(contact)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPersonIndexRow = tableView.indexPathForSelectedRow?.row
        // get all instances of Contact in the database
        let contacts = self.realm.objects(Contact.self)
        
        let alert = UIAlertController(title: "Update Contact", message: nil, preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.text = self.people[selectedPersonIndexRow!].name
        }
        alert.addTextField() { textField in
            textField.text = self.people[selectedPersonIndexRow!].phone
        }
        
        alert.addAction(UIAlertAction(title: "Update", style: .default) { _ in
            
            guard let nameTextField = alert.textFields?.first,
                  let phoneTextField = alert.textFields?.last else { return }

            // get values from the name and phone fields
            guard let updatedName = nameTextField.text,
                  let updatedPhone = phoneTextField.text else { return }

            do {
                try self.realm.write {
                    // update the table values
                    self.people[selectedPersonIndexRow!].name = updatedName
                    self.people[selectedPersonIndexRow!].phone = updatedPhone

                    // update the realmDB values
                    let updatedContact = Contact(name: updatedName, phone: updatedPhone)
                    self.realm.add(updatedContact, update: .modified)
                }
                self.realm.refresh()
            }
            catch let e {
                print(e.localizedDescription)
            }

            tableView.reloadData()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            alert.dismiss(animated: true)
        })
        
        present(alert, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { return .delete }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}

