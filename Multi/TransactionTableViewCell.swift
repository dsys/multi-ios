//
//  TransactionTableViewCell.swift
//  Multi
//
//  Created by Andrew Gold on 7/4/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    public var transactionDisplayInformation: TransactionDisplayInformation? {
        didSet {
            iconImageView.image = transactionDisplayInformation?.iconImage
            contactLabel.text = transactionDisplayInformation?.contactString
            timestampLabel.text = transactionDisplayInformation?.timestampString
            amountLabel.text = transactionDisplayInformation?.amountString
        }
    }

    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()
    private let contactLabel: UILabel = {
        let contactLabel = UILabel()
        contactLabel.lineBreakMode = .byTruncatingMiddle
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        return contactLabel
    }()
    private let timestampLabel: UILabel = {
        let timestampLabel = UILabel()
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        return timestampLabel
    }()
    private let amountLabel: UILabel = {
        let amountLabel = UILabel()
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        return amountLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let contentView = self.contentView
        contentView.addSubview(iconImageView)
        contentView.addSubview(contactLabel)
        contentView.addSubview(timestampLabel)
        contentView.addSubview(amountLabel)
        
        self.initializeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeConstraints() {
        let layoutGuide = self.contentView.safeAreaLayoutGuide
        let padding = CGFloat(8)
        let imageViewSize = CGFloat(36)
    
        iconImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: padding).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
        
        contactLabel.widthAnchor.constraint(lessThanOrEqualTo: layoutGuide.widthAnchor, multiplier: 0.66, constant: -imageViewSize).isActive = true
        contactLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: padding).isActive = true
        contactLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: padding).isActive = true
        
        timestampLabel.widthAnchor.constraint(equalTo: contactLabel.widthAnchor).isActive = true
        timestampLabel.leadingAnchor.constraint(equalTo: contactLabel.leadingAnchor).isActive = true
        timestampLabel.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: padding).isActive = true
        timestampLabel.bottomAnchor.constraint(lessThanOrEqualTo: layoutGuide.bottomAnchor, constant: -padding).isActive = true
        
        amountLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: padding).isActive = true
        amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contactLabel.trailingAnchor, constant: padding).isActive = true
        amountLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -padding).isActive = true
    }
}
