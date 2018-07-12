//
//  DAppCollectionViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/9/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class DAppCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "DAppCellReuseIdentifier"
    private var dAppManager: DAppManager = {
        return DAppManager.sharedManager!
    }()
    
    init() {
        let padding: CGFloat = 25
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: 72, height: 72)
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = padding
        collectionViewLayout.minimumLineSpacing = padding
        collectionViewLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        super.init(collectionViewLayout: collectionViewLayout)
        
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        self.title = "Apps"
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateDAppIcon(notification:)), name: .didUpdateDAppIcon, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let collectionView = self.collectionView
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.backgroundColor = UIColor.white
        collectionView!.register(DAppCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    @objc private func didUpdateDAppIcon(notification: Notification) {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    private func initializeConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        let collectionView = self.collectionView
        collectionView?.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 16).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -16).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    private func viewControllerForDApp(dApp: DApp) -> UIViewController? {
        guard let url = URL(string: dApp.url!) else {
            return nil
        }
        
        if url.scheme == "https" {
            return DAppWebViewController(dApp: dApp)
        }
        
        if url.scheme == "multi" {
            guard let host = url.host else {
                return nil
            }
            
            guard let dAppViewController: AnyClass = NSClassFromString("Multi." + host) else {
                return nil
            }
            let viewControllerClass: UIViewController.Type = dAppViewController as! UIViewController.Type
            return viewControllerClass.init()
        }
        
        return nil
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dAppManager.dApps.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DAppCollectionViewCell
    
        cell.icon = dAppManager.iconForDApp(dAppManager.dApps[indexPath.row])
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = viewControllerForDApp(dApp: dAppManager.dApps[indexPath.row]) else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
