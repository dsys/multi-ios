//
//  APIManager.swift
//  Multi
//
//  Created by Andrew Gold on 7/3/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import Apollo

class APIManager: NSObject {
    public static let sharedManager = APIManager()
    private let apollo = ApolloClient(url: URL(string: "https://api-staging.multi.app")!)
    private let queue = DispatchQueue(label: "com.multi.BlockchainAPIManager", qos: .userInteractive, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    private override init() {
        super.init()
    }
    
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
    
    public func checkIfUsernameIsValid(name: String, completion: @escaping (Bool, String?) -> Void) {
        // Implement when API is ready
        completion(true, nil)
    }
    
    public func startPhoneNumberVerification(phoneNumber: String, completion: @escaping (Bool, String?) -> ()) {
        apollo.perform(mutation: StartPhoneNumberVerificationMutation(phoneNumber: phoneNumber), queue: queue) { (result, error) in
            if error != nil {
                completion(false, nil)
                return
            }
            
            completion(result?.data?.startPhoneNumberVerification?.ok ?? false, nil)
        }
    }
}
