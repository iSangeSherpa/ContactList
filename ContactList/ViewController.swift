//
//  ViewController.swift
//  RealmExtended
//
//  Created by Sange Sherpa on 26/06/2023.
//

import UIKit
import RealmSwift
import SnapKit
import RxCocoa
import RxSwift

class Contact: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name = ""
    @Persisted var phone = ""
    
    convenience init(name: String = "", phone: String = "") {
        self.init()
        self.name = name
        self.phone = phone
    }
}


class ViewController: UIViewController {
    
    var notificationToken: NotificationToken?
    let realm = try! Realm()
    
    var people = [
        Contact(name: "Mike", phone: "12345"),
        Contact(name: "Mark", phone: "91723"),
        Contact(name: "Jane", phone: "213422"),
        Contact(name: "John", phone: "972343"),
        Contact(name: "Nile", phone: "723948")
    ]
    
    lazy var table: UITableView = {
        var table = UITableView()
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    var button: UIButton = {
        var btn = UIButton()
        btn.setTitle("Add Contact", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 3
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! realm.write {
            realm.deleteAll()
        }
        
        setup()
    }
    
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(table)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(addContactTapped), for: .touchUpInside)
        
        table.snp.makeConstraints { make in
            make.left.top.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().offset(-100)
        }
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.width.equalTo(300)
        }


        let results = self.realm.objects(Contact.self)
        self.notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let table = self?.table else { return }

            switch changes {
                case .initial:
                    table.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    table.performBatchUpdates({
                        table.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                        table.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                        table.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    }, completion: { finished in
                        print(finished)
                    })
                case .error(let error):
                    fatalError("\(error)")
            }
        }
    }


    @objc func addContactTapped() {
        let alert = UIAlertController(title: "Add Contact", message: nil, preferredStyle: .alert)
        alert.addTextField { newTextField in
            newTextField.placeholder = "Name"
        }
        alert.addTextField { newTextField in
            newTextField.placeholder = "+977"
            newTextField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard let nameField = alert.textFields?.first,
                  let phoneField = alert.textFields?.last else { return }
            
            let newContact = Contact(name: nameField.text!, phone: phoneField.text!)
            self.people.append(newContact)
            
            try! self.realm.write {
                self.realm.add(newContact)
                self.table.reloadData()
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            alert.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
}
