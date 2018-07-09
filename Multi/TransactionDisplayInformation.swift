//
//  TransactionDisplayInformation.swift
//  Multi
//
//  Created by Andrew Gold on 7/4/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

struct TransactionDisplayInformation {

    enum TransactionType {
        case sent
        case received
        case newContract
    }
    
    public let transactionType: TransactionType
    public let contactString: String
    public let timestampString: String
    public let amountString: String
    public var iconImage: UIImage? {
        switch transactionType {
        case .sent: return UIImage.transactionSentIcon
        case .received: return UIImage.transationReceivedIcon
        case .newContract: return UIImage.transactionNewContractIcon
        }
    }
    
    public static func forTransaction(transaction: TransactionFeedQuery.Data.EthereumAddress.Transaction, from wallet: MTWallet) -> TransactionDisplayInformation {
        var transactionType: TransactionDisplayInformation.TransactionType
        var contact: String
        if let toHex = transaction.to?.hex {
            if toHex == wallet.address?.lowercased() {
                transactionType = .received
                contact = transaction.from?.hex ?? String()
            } else {
                transactionType = .sent
                contact = toHex
            }
        } else {
            transactionType = .newContract
            contact = transaction.from?.hex ?? String()
        }
        
        var timestampString = ""
        if let timestamp = transaction.block?.timestamp {
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            timestampString = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        }
    
        return TransactionDisplayInformation(transactionType: transactionType, contactString: contact, timestampString: timestampString, amountString: transaction.value?.display ?? String())
    }
}
