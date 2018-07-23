//
//  TransactionLineItemTableViewCell.swift
//  Multi
//
//  Created by Andrew Gold on 7/23/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class LineItemTableViewCell: UITableViewCell {
    public var isTotalItem: Bool = false {
        didSet {
            if isTotalItem {
                itemTitleLabel.textColor = UIColor.black
                itemTotalLabel.font = UIFont.systemFont(ofSize: 17)
            } else {
                itemTitleLabel.textColor = UIColor.lightGray
                itemTotalLabel.font = UIFont.systemFont(ofSize: 14)
            }
        }
    }
    public var lineItem: (String,String)? {
        didSet {
            itemTitleLabel.text = lineItem!.0.uppercased()
            itemTotalLabel.text = lineItem!.1
        }
    }
    private let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let itemTotalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(itemTitleLabel)
        contentView.addSubview(itemTotalLabel)
        
        initializeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeConstraints() {
        let layoutGuide = contentView.safeAreaLayoutGuide
        
        itemTitleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        itemTitleLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true

        itemTotalLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -15).isActive = true
        itemTotalLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
    }
}

class TransactionLineItemTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    let lineItemCellReuseIdentifier = "LineItemCellReuseIdentifier"
    public var lineItems: [(String,String)]? {
        didSet {
            tableView.reloadData()
        }
    }
    private let tableView: UITableView = UITableView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LineItemTableViewCell.self, forCellReuseIdentifier: lineItemCellReuseIdentifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.alwaysBounceVertical = false
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        contentView.addSubview(tableView)
        
        initializeConstraints()        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let lineItemCount = lineItems?.count else { return 0 }
        
        if indexPath.row == lineItemCount - 1 {
            return 25
        }
        
        return 20
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeConstraints() {
        let layoutGuide = contentView.safeAreaLayoutGuide
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 135).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 13).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -15).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: lineItemCellReuseIdentifier) as! LineItemTableViewCell
        let lineItem = lineItems![indexPath.row]
        
        cell.lineItem = lineItem
        cell.isTotalItem = lineItem == (lineItems?.last!)!
        return cell
    }
}
