//
//  WalletCreationManager.swift
//  Multi
//
//  Created by Andrew Gold on 7/5/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import BitcoinKit
import UIKit

fileprivate let APINetwork: ETHEREUM_NETWORK = .ropsten
fileprivate let BitcoinKitNetwork: Network = .testnet

enum WalletGeneration {
    enum Step {
        case setUpNewOrLinkExisting
        case enterName
        case enterPhoneNumber
        case enterPhoneNumberVerification
        case linkOtherDevice
        case enterPassphrase
    }
    
    enum SetupType: String {
        case setUpNewAccount = "SetUpNewAccount"
        case linkExistingAccount = "LinkExistingAccount"
    }
}

struct NewWalletInfo {
    let publicKey: String!
    let privateKey: String!
    var setupType: WalletGeneration.SetupType?
    var username: String?
    var phoneNumber: String?
    var phoneNumberToken: String?
    var managerAddresses: [String]!
    var network: ETHEREUM_NETWORK = APINetwork
    var passphraseRecoveryHash: String?
    var socialRecoveryAddresses: [String]?
    var contractAddress: String?
    
    init(publicKey: String, privateKey: String, address: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.managerAddresses = [ address ]
    }
}

protocol WalletGenerationStepDelegate: AnyObject {
    func userInputInfo(_ info: String?, forStep step: WalletGenerationStepViewController)
}

public typealias WalletVerificationStepCompletionBlock = (Bool, String?) -> Void

class WalletGenerationManager: NSObject {
    private let apiManager = APIManager.sharedManager
    private var navigationController: UINavigationController?
    private var walletCreationCompletion: ((MTWallet?) -> Void)?
    private lazy var newWalletInfo: NewWalletInfo = {
       return generateNewWalletInfo()
    }()
    private var walletManager: WalletManager = {
        return WalletManager.sharedManager!
    }()
    
    func createWallet(presentingViewController: UIViewController, completion: ((MTWallet?) -> Void)?) {
        walletCreationCompletion = completion
        
        let firstStep = WalletGenerationTypeSelectionViewController()
        firstStep.walletGenerationStepDelegate = self

        navigationController = UINavigationController(rootViewController: firstStep)
        let navigationBar = navigationController?.navigationBar
        navigationBar?.isTranslucent = true
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.tintColor = UIColor.white
        presentingViewController.present(navigationController!, animated: true, completion: nil)
    }
    
    private func generateNewWalletInfo() -> NewWalletInfo {
        let mnemonic = try! Mnemonic.generate()
        let seed = Mnemonic.seed(mnemonic: mnemonic)
        let hdWallet = HDWallet(seed: seed, network: BitcoinKitNetwork)
        
        let walletInfo = NewWalletInfo(publicKey: hdWallet.publicKey.extended(), privateKey: hdWallet.privateKey.extended(), address: hdWallet.address)
        return walletInfo
    }
    
    private func didSelectSetupNewOrLinkExisting(setupType: WalletGeneration.SetupType, viewController: WalletGenerationStepViewController) {
        newWalletInfo.setupType = setupType
        var nextStep: WalletGenerationStepViewController
        switch setupType {
        case .setUpNewAccount:
            nextStep = WalletGenerationUsernameViewController()
            break
        case .linkExistingAccount:
            nextStep = WalletGenerationLinkDeviceViewController(setupType: setupType)
            break
        }

        nextStep.walletGenerationStepDelegate = self
        navigationController?.pushViewController(nextStep, animated: true)
    }
    
    private func didEnterUsername(username: String, viewController: WalletGenerationStepViewController) {
        viewController.isLoading = true
        let domain = username + ".multiapp.eth"
        checkUsername(username: domain) { (success, message) in
            viewController.isLoading = false
            if !success {
                viewController.additionalInfoLabelText = message
                return
            }
            
            let nextStep = WalletGenerationPhoneNumberViewController()
            nextStep.walletGenerationStepDelegate = self
            self.navigationController?.pushViewController(nextStep, animated: true)
        }
    }
    
    private func didEnterPhoneNumber(phoneNumber: String, viewController: WalletGenerationStepViewController) {
        viewController.isLoading = true
        startPhoneNumberVerification(phoneNumber: phoneNumber) { (success, message) in
            viewController.isLoading = false
            if !success {
                viewController.additionalInfoLabelText = message
                return
            }
            
            let nextStep = WalletGenerationPhoneVerificationViewController()
            nextStep.walletGenerationStepDelegate = self
            self.navigationController?.pushViewController(nextStep, animated: true)
        }
    }
    
    private func didEnterPhoneNumberVerification(verificationCode: String, viewController: WalletGenerationStepViewController) {
        viewController.isLoading = true
        checkPhoneNumberVerification(verificationCode: verificationCode) { (success, message) in
            viewController.isLoading = false
            if !success {
                viewController.additionalInfoLabelText = message
                return
            }
            
            let nextStep = WalletGenerationLinkDeviceViewController(setupType: self.newWalletInfo.setupType!)
            nextStep.walletGenerationStepDelegate = self
            self.navigationController?.pushViewController(nextStep, animated: true)
        }
    }
    
    private func didAttemptToLinkOtherDevice(info: String?, viewController: WalletGenerationStepViewController) {
        viewController.isLoading = true
        let presentPassphraseBlock = {
            let nextStep = WalletGenerationPassphraseViewController()
            nextStep.walletGenerationStepDelegate = self
            self.navigationController?.pushViewController(nextStep, animated: true)
        }
        
        guard let otherDeviceInfo = info else {
            presentPassphraseBlock()
            return
        }
        
        checkOtherDeviceInfo(otherDeviceInfo: otherDeviceInfo) { (success, message) in
            viewController.isLoading = false
            if !success {
                let alertController = UIAlertController(title: "Error linking other device", message: "There was an error linking your other device. Would you like to enter a passphrase instead?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "Enter Passphrase", style: .default, handler: { _ in
                    presentPassphraseBlock()
                }))
                return
            }
            
            let nextStep = WalletGenerationCreatingIdentityViewController(setupType: self.newWalletInfo.setupType!)
            self.navigationController?.pushViewController(nextStep, animated: true)
            self.createIdentityContract(completion: { (success, message) in
                if success {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    private func didEnterPassphrase(passphrase: String, viewController: WalletGenerationStepViewController) {
        viewController.isLoading = true
        newWalletInfo.passphraseRecoveryHash = passphrase.passphraseHash()
        generateAndSaveWallet(newWallet: newWalletInfo)
    }
        
    private func generateAndSaveWallet(newWallet: NewWalletInfo) {
        assert(newWallet.username != nil)
        assert(newWallet.phoneNumberToken != nil)
        assert(newWallet.managerAddresses.count >= 2 || newWallet.passphraseRecoveryHash != nil)
        navigationController?.pushViewController(WalletGenerationCreatingIdentityViewController(), animated: true)
        createIdentityContract(completion: { (success, message) in
            if success {
                let wallet = WalletManager.sharedManager?.saveWallet(username: self.newWalletInfo.username!,
                                                                     publicKey: self.newWalletInfo.publicKey,
                                                                     privateKey: self.newWalletInfo.privateKey,
                                                                     contractAddress: self.newWalletInfo.contractAddress!,
                                                                     network: self.newWalletInfo.network)
                if let completion = self.walletCreationCompletion {
                    completion(wallet)
                }

                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    private func checkUsername(username: String, completion: @escaping WalletVerificationStepCompletionBlock) {
        apiManager.checkUsernameAvailable(username: username) { (success, message) in
            DispatchQueue.main.async {
                if success {
                    self.newWalletInfo.username = username
                }
                
                completion(success, message)
            }
        }
    }
    
    private func startPhoneNumberVerification(phoneNumber: String, completion: @escaping WalletVerificationStepCompletionBlock) {
        apiManager.startPhoneNumberVerification(phoneNumber: phoneNumber) { (success, message) in
            DispatchQueue.main.async {
                if success {
                    self.newWalletInfo.phoneNumber = phoneNumber
                }
                
                completion(success, message)
            }
        }
    }
    
    private func checkPhoneNumberVerification(verificationCode: String, completion: @escaping WalletVerificationStepCompletionBlock) {
        guard let phoneNumber = newWalletInfo.phoneNumber else {
            completion(false, "No phone number entered")
            return
        }
    
        apiManager.checkPhoneNumberVerification(phoneNumber: phoneNumber, verificationCode: verificationCode) { (success, message, hashedPhoneNumber, phoneNumberToken, phoneNumberTokenExpires) in
            DispatchQueue.main.async {
                if success {
                    self.newWalletInfo.phoneNumberToken = phoneNumberToken
                }
                
                completion(success, message)
            }
        }
    }
    
    private func checkOtherDeviceInfo(otherDeviceInfo: String, completion: @escaping WalletVerificationStepCompletionBlock) {
        apiManager.checkOtherDeviceInfo(otherDeviceInfo: otherDeviceInfo) { (success, message, managerAddresses) in
            DispatchQueue.main.async {
                if success {
                    self.newWalletInfo.managerAddresses += managerAddresses
                }
                
                completion(success, message)
            }
        }
    }
    
    private func createIdentityContract(completion: @escaping WalletVerificationStepCompletionBlock) {
        apiManager.createIdentityContract(username: newWalletInfo.username!, phoneNumberToken: newWalletInfo.phoneNumberToken!, managerAddresses: newWalletInfo.managerAddresses, network: newWalletInfo.network, passphraseRecoveryHash: newWalletInfo.passphraseRecoveryHash, socialRecoveryAddresses: newWalletInfo.socialRecoveryAddresses) { (contractAddress) in
            DispatchQueue.main.async {
                self.newWalletInfo.contractAddress = contractAddress
                completion(contractAddress != nil, contractAddress)
            }
        }
    }
}

extension WalletGenerationManager: WalletGenerationStepDelegate {
    func userInputInfo(_ info: String?, forStep step: WalletGenerationStepViewController) {
        switch step.walletGenerationStepType {
        case .setUpNewOrLinkExisting?:
            guard let setupType = WalletGeneration.SetupType(rawValue: info!) else { return }
            didSelectSetupNewOrLinkExisting(setupType: setupType, viewController: step)
        case .enterName?:
            didEnterUsername(username: info!, viewController: step)
        case .enterPhoneNumber?:
            didEnterPhoneNumber(phoneNumber: info!, viewController: step)
        case .enterPhoneNumberVerification?:
            didEnterPhoneNumberVerification(verificationCode: info!, viewController: step)
        case .linkOtherDevice?:
            didAttemptToLinkOtherDevice(info: info, viewController: step)
        case .enterPassphrase?:
            didEnterPassphrase(passphrase: info!, viewController: step)
        default:
            assertionFailure()
        }
    }
}
