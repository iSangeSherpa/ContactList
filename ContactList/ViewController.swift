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
    
    let people = [
        Contact(name: "Mike", phone: "12345"),
        Contact(name: "Mark", phone: "91723"),
        Contact(name: "Jane", phone: "213422"),
        Contact(name: "John", phone: "972343"),
        Contact(name: "Nile", phone: "723948")
    ]
    
    let tableDataSource = PublishSubject<[Contact]>()
    let disposeBag = DisposeBag()
    
    lazy var table: UITableView = {
        var table = UITableView()
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        table.delegate = self
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindTable()
        realmConfig()
    }
    
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(table)
        
        table.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    private func bindTable() {
        tableDataSource.bind(to: table.rx.items) { table, index, cell in
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell = table.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
            cell.titleLabel.text = "\(self.people[index].name)"
            cell.metaLabel.text = "\(self.people[index].phone)"
            return cell
        }
        .disposed(by: disposeBag)
        
        tableDataSource.onNext(people)
    }
    
    private func realmConfig() {
        try! realm.write {
            for contact in people {
                realm.add(contact)
            }
        }
    }

}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
