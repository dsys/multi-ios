//
//  BlockchainAPIManager.swift
//  Multi
//
//  Created by Andrew Gold on 7/3/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import Apollo

class BlockchainAPIManager: NSObject {
    
    private let apollo = ApolloClient(url: URL(string: "https://api-staging.multi.app")!)
    private let queue = DispatchQueue(label: "com.multi.BlockchainAPIManager", qos: .userInteractive, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    var transactionWatcher: GraphQLQueryWatcher<TransactionFeedQuery>?
    public func fetchTransactionsFor(forAddress address: String, onNework network: String, completion: @escaping ([TransactionFeedQuery.Data.EthereumAddress.Transaction]?) -> Void) {
        transactionWatcher = apollo.watch(query: TransactionFeedQuery(address: address, network: ETHEREUM_NETWORK(rawValue: network)), cachePolicy: .returnCacheDataElseFetch, queue: queue, resultHandler: { (result, error) in
            if error != nil {
                completion(nil)
                return
            }
            
            completion(result?.data?.ethereumAddress?.transactions)
        })
    }
}
