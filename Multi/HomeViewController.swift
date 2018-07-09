//
//  HomeViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/3/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    private let blockchainAPIManager = BlockchainAPIManager()
    private let walletManager: WalletManager!
    private let dAppManager: DAppManager
    private lazy var walletCreationManager: WalletGenerationManager = {
        return WalletGenerationManager(walletManager: walletManager)
    }()
    private let transactionTableViewController: TransactionTableViewController!
    private let dAppTableViewController: DAppTableViewController!
    private var shouldShowWalletCreationView: Bool = true
    
    init(walletManager: WalletManager, dAppManager: DAppManager) {
        self.walletManager = walletManager
        self.dAppManager = dAppManager
        transactionTableViewController = TransactionTableViewController(blockchainAPIManager: blockchainAPIManager)
        dAppTableViewController = DAppTableViewController(dAppManager: dAppManager)
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = [ UINavigationController(rootViewController: transactionTableViewController), UINavigationController(rootViewController: dAppTableViewController) ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let wallets = walletManager.wallets
        if wallets.count > 0 {
            return
        }

        if !shouldShowWalletCreationView {
            return
        }
        
        walletCreationManager.createWallet(presentingViewController: self) { (wallet) in
            self.transactionTableViewController.wallet = wallet
        }
        shouldShowWalletCreationView = false
    }
}
