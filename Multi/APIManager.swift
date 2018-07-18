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
    private let defaultErrorMessage = "An error occurred"
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
    
    
    public func checkUsernameAvailable(username: String, completion: @escaping (_ success: Bool, _ message: String?) -> Void) {
        apollo.perform(mutation: CheckUsernameAvailableMutation(username: username), queue: queue) { (result, error) in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let checkUsernameAvailable = result?.data?.checkUsernameAvailable else {
                completion(false, self.defaultErrorMessage)
                return
            }
            
            completion(checkUsernameAvailable.ok ?? false, checkUsernameAvailable.message)
        }
    }
    
    public func startPhoneNumberVerification(phoneNumber: String, completion: @escaping (_ success: Bool, _ message: String?) -> Void) {
        apollo.perform(mutation: StartPhoneNumberVerificationMutation(phoneNumber: phoneNumber), queue: queue) { (result, error) in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let startPhoneNumberVerification = result?.data?.startPhoneNumberVerification else {
                completion(false, self.defaultErrorMessage)
                return
            }
            
            completion(startPhoneNumberVerification.ok ?? false, startPhoneNumberVerification.message)
        }
    }
    
    public func checkPhoneNumberVerification(phoneNumber: String, verificationCode: String, completion: @escaping (_ success: Bool, _ message: String?, _ hashedPhoneNumber: String?, _ phoneNumberToken: String?, _ phoneNumberTokenExpires: String?) -> Void) {
        apollo.perform(mutation: CheckPhoneNumberVerificationMutation(phoneNumber: phoneNumber, verificationCode: verificationCode), queue: queue) { (result, error) in
            if let error = error {
                completion(false, error.localizedDescription, nil, nil, nil)
                return
            }
            
            guard let checkPhoneNumberVerification = result?.data?.checkPhoneNumberVerification else {
                completion(false, self.defaultErrorMessage, nil, nil, nil)
                return
            }

            completion(checkPhoneNumberVerification.ok ?? false,
                       checkPhoneNumberVerification.message,
                       checkPhoneNumberVerification.phoneNumber?.hashedPhoneNumber,
                       checkPhoneNumberVerification.phoneNumberToken,
                       checkPhoneNumberVerification.phoneNumberTokenExpires)
        }
    }
    
    public func checkOtherDeviceInfo(otherDeviceInfo: String, completion: @escaping (_ success: Bool, _ message: String?, _ managerAddresses: [String]) -> Void) {
        // Waiting on API
        completion(true, nil, [])
    }
    
    public func createIdentityContract(username: String, phoneNumberToken: String, managerAddresses: [String], network: ETHEREUM_NETWORK, passphraseRecoveryHash: String?, socialRecoveryAddresses: [String]?, completion: @escaping (String?) -> Void) {
        apollo.perform(mutation: CreateIdentityContractMutation(username: username, phoneNumberToken: phoneNumberToken, managerAddresses: managerAddresses, socialRecoveryAddresses: socialRecoveryAddresses), queue: queue) { (result, error) in
            if error != nil {
                completion(nil)
                return
            }
            
            completion(result?.data?.createIdentityContract?.identityContract?.address.display)
        }
    }
    
    public func getDeviceLinkingQRPayload(completion: @escaping (String?) -> Void) {
        // Waiting on API
        completion("Dummy payload")
    }
    
    private func test_delay(_ block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            block()
        }
    }
}
