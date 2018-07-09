//
//  WalletManagerTests.swift
//  MultiTests
//
//  Created by Andrew Gold on 7/2/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import CoreData
import XCTest
@testable import Multi

class WalletManagerTests: XCTestCase {
    
    var walletManager: WalletManager?
    
    override func setUp() {
        super.setUp()
        
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        walletManager = WalletManager(managedObjectContext: managedObjectContext)
    }
    
    func testKeyGeneration() {
        let mnemonic = walletManager!.newMnemonic()
        let wallet1 = walletManager!.generateWallet(name: "Wallet 1", mnemonic: mnemonic!)
        XCTAssertNotNil(wallet1)
        
        let wallet2 = walletManager!.generateWallet(name: "Wallet 2", mnemonic: mnemonic!)
        XCTAssertNotNil(wallet2)
        
        XCTAssertEqual(wallet1!.publicKey, wallet2!.publicKey)
        XCTAssertEqual(wallet1!.privateKey, wallet2!.privateKey)
        XCTAssertEqual(wallet1!.address, wallet2!.address)
        
        let otherMnemonic = walletManager!.newMnemonic()
        XCTAssertNotEqual(mnemonic, otherMnemonic!)

        let wallet3 = walletManager!.generateWallet(name: "Wallet 3", mnemonic: otherMnemonic!)
        XCTAssertNotNil(wallet3)
        
        XCTAssertNotEqual(wallet1!.publicKey, wallet3!.publicKey)
        XCTAssertNotEqual(wallet1!.privateKey, wallet3!.privateKey)
        XCTAssertNotEqual(wallet1!.address, wallet3!.address)
}
    
    func testSavingWallet() {
        let mnemonic = walletManager!.newMnemonic()
        let wallet = walletManager!.generateWallet(name: "Wallet", mnemonic: mnemonic!)
        walletManager!.saveWallet(wallet: wallet!)
        
        XCTAssert(walletManager!.wallets.contains(wallet!))
    }
}
