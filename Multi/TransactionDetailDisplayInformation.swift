//
//  TransactionDetailDisplayInformation.swift
//  Multi
//
//  Created by Andrew Gold on 7/23/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

struct TransactionDetailDisplayInformation {
    let walletName: String
    let walletBalanance: String
    let recipientName: String
    let recipientDetail: String
    let recipientIcon: UIImage?
    let messageTitle: String
    let messageText: String
    let lineItems: [(String,String)]
    let requiresApproval: Bool
}
