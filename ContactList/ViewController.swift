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
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var name = ""
    @objc dynamic var phone = ""
    
    convenience init(name: String = "", phone: String = "") {
        self.init()
        self.name = name
        self.phone = phone
    }
    
    override class func primaryKey() -> String? {
        return "_id"
    }
}


class ViewController: UIViewController {
    
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
        btn.setTitle("Edit", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! realm.write {
            realm.deleteAll()
        }
        
        setup()
        realmConfig()
    }
    
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(table)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        
        table.snp.makeConstraints { make in
            make.left.top.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().offset(-300)
        }
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(table.snp.bottom).offset(100)
            make.width.equalTo(300)
        }
    }
    
    @objc func editTapped() {
        if table.isEditing == true {
            table.isEditing = false
        } else {
            table.isEditing = true
        }
    }
    
    
    private func realmConfig() {
        try! realm.write {
            for contact in people {
                realm.add(contact)
            }
        }
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return people.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        let currentPerson = people[indexPath.row]
        cell.titleLabel.text = currentPerson.name
        cell.metaLabel.text = currentPerson.phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 80 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { return .delete }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return true }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        people.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    
}
