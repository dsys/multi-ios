//
//  HomeViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/3/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController {
    private lazy var walletCreationManager: WalletGenerationManager = {
        return WalletGenerationManager()
    }()
    private var dAppCollectionViewController: DAppCollectionViewController?
    private var shouldShowWalletCreationView: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dAppCollectionViewController = DAppCollectionViewController()
        let navigationController = UINavigationController(rootViewController: dAppCollectionViewController!)
        self.view.addSubview(navigationController.view)
        self.addChildViewController(navigationController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let wallets = WalletManager.sharedManager!.wallets
        if wallets.count > 0 {
            registerForPushNotificationsIfNeeded()
            return
        }

        if !shouldShowWalletCreationView {
            return
        }
        
        walletCreationManager.createWallet(presentingViewController: self, completion: nil)
        shouldShowWalletCreationView = false
    }
    
    private func registerForPushNotificationsIfNeeded() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized { return }
            notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}
