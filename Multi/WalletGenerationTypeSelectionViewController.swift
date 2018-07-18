//
//  WalletTypeSelectionViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/6/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationTypeSelectionViewController: WalletGenerationStepViewController {
    let singleDeviceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create a new identity", for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(selectedType(button:)), for: .primaryActionTriggered)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }()
    let multiDeviceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Link existing account", for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(selectedType(button:)), for: .primaryActionTriggered)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        walletGenerationStepType = .setUpNewOrLinkExisting
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDescriptionLabelText(text: "Welcome.")
        self.showsLogoImageView = true
        
        view.addSubview(singleDeviceButton)
        view.addSubview(multiDeviceButton)

        initializeConstraints()
    }
    
    private func initializeConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide

        singleDeviceButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        singleDeviceButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 100).isActive = true

        multiDeviceButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        multiDeviceButton.topAnchor.constraint(equalTo: singleDeviceButton.topAnchor, constant: 60).isActive = true
    }
    
    @objc private func selectedType(button: UIButton) {
        var info = String()
        if button == singleDeviceButton {
            info = WalletGeneration.SetupType.setUpNewAccount.rawValue
        }
        
        if button == multiDeviceButton {
            info = WalletGeneration.SetupType.linkExistingAccount.rawValue
        }
        
        walletGenerationStepDelegate?.userInputInfo(info, forStep: self)
    }

}
