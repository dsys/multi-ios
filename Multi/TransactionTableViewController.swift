//
//  ActivityTableViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/3/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class TransactionTableViewController: UITableViewController {
    private let cellReuseIdentifier = "TransactionListTableViewCellReuseIdentifier"
    public var wallet: MTWallet? {
        didSet {
            fetchData()
        }
    }
    private var transactions: [TransactionFeedQuery.Data.EthereumAddress.Transaction]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    init() {
        super.init(style: .plain)
        self.title = "Recent Activity"
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        self.wallet = WalletManager.sharedManager?.debugWallet
    }
    
    private func fetchData() {
        guard let wallet = self.wallet else { return }
        APIManager.sharedManager.fetchTransactionsFor(forAddress: wallet.address!, onNework: wallet.network!) { (transactions) in
            DispatchQueue.main.async {
                self.transactions = transactions?.reversed()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TransactionTableViewCell
        guard let transaction = transactions?[indexPath.row] else {
            assertionFailure()
            return cell
        }

        cell.transactionDisplayInformation = TransactionDisplayInformation.forTransaction(transaction: transaction, from: wallet!)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewControler = TransactionDetailViewController()
        viewControler.delegate = self
        self.present(viewControler, animated: true, completion: nil)
    }
}

extension TransactionTableViewController: TransactionDetailViewControllerDelegate {
    func willDismiss(transactionDetailViewController: TransactionDetailViewController) {
        guard let indexPathForSelectedRow = tableView.indexPathForSelectedRow else {
            assertionFailure()
            return
        }
        
        tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
    }
}
