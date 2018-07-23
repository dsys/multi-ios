//
//  TransactionDetailInformationTableViewCell.swift
//  Multi
//
//  Created by Andrew Gold on 7/23/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class TransactionDetailInformationTableViewCell: UITableViewCell {
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let label1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let label2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(label1)
        contentView.addSubview(label2)
        
        initializeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeConstraints() {
        let layoutGuide = contentView.safeAreaLayoutGuide
        
        titleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 120).isActive = true
        
        label1.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15).isActive = true
        label1.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 15).isActive = true
        label1.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -15).isActive = true
        
        label2.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15).isActive = true
        label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 8).isActive = true
        label2.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -15).isActive = true
        label2.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -15).isActive = true
    }
}
