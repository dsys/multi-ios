//
//  TransactionDetailHeaderTableViewCell.swift
//  Multi
//
//  Created by Andrew Gold on 7/19/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class TransactionDetailHeaderTableViewCell: UITableViewCell {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.multiLogoImage)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.multiBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    public let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(doneButton)
        
        initializeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeConstraints() {
        doneButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        logoImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
}
