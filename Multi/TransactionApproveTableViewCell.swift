//
//  TransactionDetailApproveTableViewCell.swift
//  Multi
//
//  Created by Andrew Gold on 7/23/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class TransactionApproveTableViewCell: UITableViewCell {
    public let approveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Approve", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(approveButton)
        initializeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeConstraints() {
        let layoutGuide = contentView.safeAreaLayoutGuide
        
        approveButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        approveButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 10).isActive = true
        approveButton.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -10).isActive = true
    }

}
