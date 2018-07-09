//
//  DAppTableViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/9/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class DAppTableViewController: UITableViewController {
    private let reuseIdentifier = "DAppCellReuseIdentifier"
    private let dAppManager: DAppManager!
    
    init(dAppManager: DAppManager) {
        self.dAppManager = dAppManager
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        self.title = "Apps"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dAppManager.dApps.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.textLabel!.text = dAppManager.dApps[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(DAppViewController(dApp: dAppManager.dApps[indexPath.row]), animated: true)
    }

}
