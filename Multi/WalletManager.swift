//
//  WalletManager.swift
//  Multi
//
//  Created by Andrew Gold on 7/2/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import CoreData
import Foundation

class WalletManager: NSObject {
    private static var sharedWalletManagerInstance: WalletManager?
    public static var sharedManager: WalletManager? {
        get {
            return sharedWalletManagerInstance
        }
        set (newSharedWalletManager) {
            assert(sharedWalletManagerInstance == nil)
            sharedWalletManagerInstance = newSharedWalletManager
        }
    }
    private let managedObjectContext: NSManagedObjectContext
    public private(set) lazy var wallets: [MTWallet] = {
        return fetchWallets()
    }()
    public var debugWallet: MTWallet {
        let wallet = MTWallet(context: managedObjectContext)
        wallet.name = "DEBUG"
        wallet.address = "0x1394B50D8Fca528E51aa75178C64d72d2b6Adf81"
        wallet.network = ETHEREUM_NETWORK.mainnet.rawValue
        wallet.publicKey = "pub123456789"
        wallet.privateKey = "prv123456789"
        
        return wallet
    }
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init()
    }
    
    public func saveWallet(username: String, publicKey: String, privateKey: String, contractAddress: String, network: ETHEREUM_NETWORK) -> MTWallet {
        let wallet = MTWallet(context: managedObjectContext)
        wallet.name = username
        wallet.address = contractAddress
        wallet.publicKey = publicKey
        wallet.privateKey = privateKey
        wallet.network = network.rawValue

        wallets.append(wallet)
        managedObjectContext.insert(wallet)
        
        return wallet
    }
    
    private func fetchWallets() -> [MTWallet] {
        guard let wallets = try? managedObjectContext.fetch(NSFetchRequest<MTWallet>(entityName: "MTWallet")) else {
            return Array()
        }
        
        return wallets
    }
}
