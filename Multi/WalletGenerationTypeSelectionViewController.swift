//
//  WalletTypeSelectionViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/6/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationTypeSelectionViewController: UIViewController, WalletGenerationStep {

    let walletGenerationStepType: WalletGeneration.Step = .setUpNewOrLinkExisting
    weak var walletGenerationStepDelegate: WalletGenerationStepDelegate?
    let singleDeviceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set up new account", for: .normal)
        button.addTarget(self, action: #selector(selectedType(button:)), for: .primaryActionTriggered)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }()
    let multiDeviceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Link existing account", for: .normal)
        button.addTarget(self, action: #selector(selectedType(button:)), for: .primaryActionTriggered)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let view = self.view
        view?.backgroundColor = UIColor.white
        
        view?.addSubview(singleDeviceButton)
        view?.addSubview(multiDeviceButton)
        
        initializeConstraints()
    }
    
    private func initializeConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        singleDeviceButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        singleDeviceButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 100).isActive = true
        
        multiDeviceButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        multiDeviceButton.topAnchor.constraint(equalTo: singleDeviceButton.bottomAnchor, constant: 100).isActive = true
    }
    
    @objc private func selectedType(button: UIButton) {
        if button == singleDeviceButton {
            walletGenerationStepDelegate?.stepCompleted(step: self, success: true, info: [ .type: WalletGeneration.SetupType.setUpNewAccount])
            return
        }
        
        if button == multiDeviceButton {
            walletGenerationStepDelegate?.stepCompleted(step: self, success: true, info: [ .type: WalletGeneration.SetupType.linkExistingAccount ])
            return
        }
        
        assertionFailure()
    }

}
