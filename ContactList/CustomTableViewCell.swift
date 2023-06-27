//
//  CustomTableViewCell.swift
//  ContactList
//
//  Created by Sange Sherpa on 27/06/2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "No Text"
        label.font = UIFont(name: "Avenir", size: 20)
        return label
    }()
    
    var metaLabel: UILabel = {
        var label = UILabel()
        label.text = "No Text"
        label.font = UIFont(name: "Avenir", size: 13)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(metaLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(20)
        }
        metaLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
