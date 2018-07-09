//
//  WalletManager.swift
//  Multi
//
//  Created by Andrew Gold on 7/2/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import BitcoinKit
import CoreData
import Foundation

class WalletManager: NSObject {

    private let managedObjectContext: NSManagedObjectContext
    public private(set) lazy var wallets: [MTWallet] = {
        return fetchWallets()
    }()
    public var debugWallet: MTWallet {
        let wallet = MTWallet(context: managedObjectContext)
        wallet.name = "DEBUG"
        wallet.address = "0x75810d3d157371C1FB7c474a90bc84672024Dbad"
        wallet.network = ETHEREUM_NETWORK.mainnet.rawValue
        wallet.publicKey = "pub123456789"
        wallet.privateKey = "prv123456789"
        
        return wallet
    }
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init()
    }
    
    public func newMnemonic() -> [String] {
        guard let mnemonic = try? Mnemonic.generate() else {
            return [String]()
        }
        
        return mnemonic
    }
    
    public func generateWallet(name: String, mnemonic: [String]) -> MTWallet? {
        let seed = Mnemonic.seed(mnemonic: mnemonic)
        let hdWallet = HDWallet(seed: seed, network: .mainnet)
        
        let wallet = MTWallet(context: managedObjectContext)
        wallet.name = name
        wallet.address = hdWallet.address
        wallet.publicKey = hdWallet.publicKey.extended()
        wallet.privateKey = hdWallet.privateKey.extended()
        wallet.network = ETHEREUM_NETWORK.mainnet.rawValue
        return wallet
    }
    
    public func saveWallet(wallet: MTWallet) {
        wallets.append(wallet)
        managedObjectContext.insert(wallet)
    }
    
    private func fetchWallets() -> [MTWallet] {
        guard let wallets = try? managedObjectContext.fetch(NSFetchRequest<MTWallet>(entityName: "MTWallet")) else {
            return Array()
        }
        
        return wallets
    }
}
