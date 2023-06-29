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
        print(realm.configuration.fileURL ?? "")
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
