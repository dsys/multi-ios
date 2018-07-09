//
//  WalletCreationManager.swift
//  Multi
//
//  Created by Andrew Gold on 7/5/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

enum WalletGeneration {
    enum Step {
        case setUpNewOrLinkExisting
        case enterName
        case enterPhoneNumber
        case enterPhoneNumberVerification
        case linkOtherDevice
        case viewMnemonic
        case enterMnemonic
    }
    
    enum Info {
        case type
        case name
        case phoneNumber
        case phoneNumberVerification
        case otherDeviceInfo
        case mnemonic
        case enteredMnemonicSuccessfully
    }
    
    enum SetupType {
        case setUpNewAccount
        case linkExistingAccount
    }
}

struct NewWalletInfo {
    var name: String?
    var address: String?
    var publicKey: String?
    var privateKey: String?
}

protocol WalletGenerationStepDelegate: AnyObject {
    func getMnemonic(walletCreator: WalletGenerationStep) -> [String]
    func stepCompleted(step: WalletGenerationStep, success: Bool, info: [WalletGeneration.Info:Any]?)
}

protocol WalletGenerationStep: AnyObject {
    var walletGenerationStepType: WalletGeneration.Step { get }
    var walletGenerationStepDelegate: WalletGenerationStepDelegate? { get set }
    var viewController: UIViewController { get }
}

extension WalletGenerationStep where Self: UIViewController {
    var viewController: UIViewController {
        return self
    }
}

class WalletGenerationManager: NSObject, WalletGenerationStepDelegate {

    let walletManager: WalletManager
    private var navigationController: UINavigationController?
    private var walletCreationCompletion: ((MTWallet?) -> Void)?
    private var newWalletInfo: NewWalletInfo?
    
    init(walletManager: WalletManager) {
        self.walletManager = walletManager
        super.init()
    }
    
    func createWallet(presentingViewController: UIViewController, completion: ((MTWallet?) -> Void)?) {
        walletCreationCompletion = completion
        newWalletInfo = NewWalletInfo()
        
        let firstStep = WalletGenerationTypeSelectionViewController()
        firstStep.walletGenerationStepDelegate = self

        navigationController = UINavigationController(rootViewController: firstStep.viewController)
        navigationController!.isNavigationBarHidden = true
        presentingViewController.present(navigationController!, animated: true, completion: nil)
    }
    
    func getMnemonic(walletCreator: WalletGenerationStep) -> [String] {
        return walletManager.newMnemonic()
    }
    
    func stepCompleted(step: WalletGenerationStep, success: Bool, info: [WalletGeneration.Info:Any]?) {
        if !success {
            assertionFailure()
            return
        }

        var nextStep: WalletGenerationStep
        switch step.walletGenerationStepType {
        case .setUpNewOrLinkExisting:
            guard let walletType = info?[.type] as! WalletGeneration.SetupType? else {
                assertionFailure()
                return
            }
            
            switch walletType {
            case .setUpNewAccount:
                nextStep = WalletGenerationInfoViewController(walletGenerationStepType: .enterName, walletGenerationInfo: .name, labelString: "Username:")
                break
            case .linkExistingAccount:
                nextStep = WalletGenerationLinkDeviceViewController()
                break
            }
            break
        case .enterName:
            guard let name = info?[.name] as! String? else {
                assertionFailure()
                return
            }
            
            newWalletInfo?.name = name
            nextStep = WalletGenerationInfoViewController(walletGenerationStepType: .enterPhoneNumber, walletGenerationInfo: .phoneNumber, labelString: "Enter Phone Number:")
            break
        case .enterPhoneNumber:
            guard let phoneNumber = info?[.phoneNumber] as! String? else {
                assertionFailure()
                return
            }
            
            verifyPhoneNumber(phoneNumber: phoneNumber)
            nextStep = WalletGenerationInfoViewController(walletGenerationStepType: .enterPhoneNumberVerification, walletGenerationInfo: .phoneNumberVerification, labelString: "Verify Phone Number:")
            break
        case .enterPhoneNumberVerification:
            guard let phoneNumberVerification = info?[.phoneNumberVerification] as! String? else {
                assertionFailure()
                return
            }
            
            verifyPhoneNumberVerification(phoneNumberVerification: phoneNumberVerification)
            nextStep = WalletGenerationLinkDeviceViewController()
            break
        case .linkOtherDevice:
            guard let name = newWalletInfo?.name else {
                assertionFailure()
                return
            }
            
            generateAndSaveWallet(name: name, mnemonic: walletManager.newMnemonic())
            navigationController?.dismiss(animated: true, completion: nil)
            return
        default:
            assertionFailure()
            return
        }
        
        nextStep.walletGenerationStepDelegate = self
        navigationController?.pushViewController(nextStep.viewController, animated: true)
    }
    
    private func generateAndSaveWallet(name: String, mnemonic: [String]) {
        guard let wallet = walletManager.generateWallet(name: name, mnemonic: mnemonic) else {
            return
        }
        
        walletManager.saveWallet(wallet: wallet)
        if let completion = walletCreationCompletion {
            completion(wallet)
        }

        navigationController!.dismiss(animated: true, completion: nil)
    }
    
    private func verifyPhoneNumber(phoneNumber: String) {
        // Need to implement
    }
    
    private func verifyPhoneNumberVerification(phoneNumberVerification: String) {
        // Need to implement
    }
}
