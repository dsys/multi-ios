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
        case enterPassphrase
    }
    
    enum Info {
        case type
        case name
        case phoneNumber
        case phoneNumberVerification
        case otherDeviceInfo
        case passphrase
    }
    
    enum SetupType {
        case setUpNewAccount
        case linkExistingAccount
    }
}

struct NewWalletInfo {
    var mnemonic: [String]!
    var type: WalletGeneration.SetupType?
    var name: String?
    var passphrase: String?
    var address: String?
    var publicKey: String?
    var privateKey: String?
    
    init(mnemonic: [String]) {
        self.mnemonic = mnemonic
    }
}

protocol WalletGenerationStepDelegate: AnyObject {
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

class WalletGenerationManager: NSObject {
    private var navigationController: UINavigationController?
    private var walletCreationCompletion: ((MTWallet?) -> Void)?
    private var newWalletInfo: NewWalletInfo?
    private var walletManager: WalletManager = {
        return WalletManager.sharedManager!
    }()
    
    func createWallet(presentingViewController: UIViewController, completion: ((MTWallet?) -> Void)?) {
        walletCreationCompletion = completion
        newWalletInfo = NewWalletInfo(mnemonic: walletManager.newMnemonic())
        
        let firstStep = WalletGenerationTypeSelectionViewController()
        firstStep.walletGenerationStepDelegate = self

        navigationController = UINavigationController(rootViewController: firstStep.viewController)
        let navigationBar = navigationController?.navigationBar
        navigationBar?.isTranslucent = true
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.tintColor = UIColor.white
        presentingViewController.present(navigationController!, animated: true, completion: nil)
    }
    
    private func didSelectSetupNewOrLinkExisting(success: Bool, info: [WalletGeneration.Info:Any]?) {
        guard let setupType = info?[.type] as! WalletGeneration.SetupType? else {
            assertionFailure()
            return
        }

        var nextStep: WalletGenerationStep
        newWalletInfo?.type = setupType
        switch setupType {
        case .setUpNewAccount:
            nextStep = WalletGenerationUsernameViewController()
            break
        case .linkExistingAccount:
            nextStep = WalletGenerationLinkDeviceViewController(setupType: setupType)
            break
        }

        nextStep.walletGenerationStepDelegate = self
        navigationController?.pushViewController(nextStep.viewController, animated: true)
    }
    
    private func didEnterName(success: Bool, info: [WalletGeneration.Info:Any]?) {
        guard let name = info?[.name] as! String? else {
            assertionFailure()
            return
        }
        
        newWalletInfo?.name = name
        let nextStep = WalletGenerationPhoneNumberViewController()
        nextStep.walletGenerationStepDelegate = self
        navigationController?.pushViewController(nextStep.viewController, animated: true)
    }
    
    private func didEnterPhoneNumber(success: Bool, info: [WalletGeneration.Info:Any]?) {
        guard let phoneNumber = info?[.phoneNumber] as! String? else {
            assertionFailure()
            return
        }
        
        verifyPhoneNumber(phoneNumber: phoneNumber)
        let nextStep = WalletGenerationPhoneVerificationViewController()
        nextStep.walletGenerationStepDelegate = self
        navigationController?.pushViewController(nextStep.viewController, animated: true)
    }
    
    private func didEnterPhoneNumberVerification(success: Bool, info: [WalletGeneration.Info:Any]?) {
        guard let phoneNumberVerification = info?[.phoneNumberVerification] as! String? else {
            assertionFailure()
            return
        }
        
        verifyPhoneNumberVerification(phoneNumberVerification: phoneNumberVerification)
        let nextStep = WalletGenerationLinkDeviceViewController(setupType: newWalletInfo!.type!)
        nextStep.walletGenerationStepDelegate = self
        navigationController?.pushViewController(nextStep.viewController, animated: true)
    }
    
    private func didAttemptToLinkOtherDevice(success: Bool, info: [WalletGeneration.Info:Any]?) {
        if !success {
            let nextStep = WalletGenerationInfoViewController(walletGenerationStepType: .enterPassphrase, walletGenerationInfo: .passphrase, labelString: "Enter a passphrase:")
            nextStep.walletGenerationStepDelegate = self
            navigationController?.pushViewController(nextStep.viewController, animated: true)
            return
        }
        
        if newWalletInfo?.type == .linkExistingAccount {
            assert(newWalletInfo?.name == nil)
            guard let name = info?[.name] as! String? else {
                assertionFailure()
                return
            }
            
            newWalletInfo?.name = name
        }
        
        generateAndSaveWallet(newWallet: newWalletInfo!)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func didEnterPassphrase(success: Bool, info: [WalletGeneration.Info:Any]?) {
        guard let passphrase = info?[.passphrase] as! String? else {
            assertionFailure()
            return
        }
        
        newWalletInfo?.passphrase = passphrase
        generateAndSaveWallet(newWallet: newWalletInfo!)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func generateAndSaveWallet(newWallet: NewWalletInfo) {
        guard let wallet = walletManager.generateWallet(name: newWallet.name!, mnemonic: newWallet.mnemonic) else { return }
        
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

extension WalletGenerationManager: WalletGenerationStepDelegate {
    func stepCompleted(step: WalletGenerationStep, success: Bool, info: [WalletGeneration.Info:Any]?) {
        switch step.walletGenerationStepType {
        case .setUpNewOrLinkExisting:
            didSelectSetupNewOrLinkExisting(success: success, info: info)
            break
        case .enterName:
            didEnterName(success: success, info: info)
            break
        case .enterPhoneNumber:
            didEnterPhoneNumber(success: success, info: info)
            break
        case .enterPhoneNumberVerification:
            didEnterPhoneNumberVerification(success: success, info: info)
            break
        case .linkOtherDevice:
            didAttemptToLinkOtherDevice(success: success, info: info)
            break
        case .enterPassphrase:
            didEnterPassphrase(success: success, info: info)
            break
        }
    }
}
