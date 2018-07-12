//
//  BlockchainAPIManagerTest.swift
//  MultiTests
//
//  Created by Andrew Gold on 7/3/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import XCTest
@testable import Multi

class APIManagerTest: XCTestCase {
    
    let address = "0x770cE920c01F6Ea237451aA83C3D90cbcae48616"
    let network = ETHEREUM_NETWORK.ropsten
    
    func testFetchTransactions() {
        let expectation = XCTestExpectation(description: "Fetched transactions")
        APIManager.sharedManager.fetchTransactionsFor(forAddress: address, onNework: network.rawValue, completion: { (transactions) in
            XCTAssertNotNil(transactions)
            XCTAssert((transactions?.count)! > 0)
            expectation.fulfill()
        })
        
        wait(for: [ expectation ], timeout: 2)
    }
}
