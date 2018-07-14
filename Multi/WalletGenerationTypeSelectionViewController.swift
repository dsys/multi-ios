//
//  WalletTypeSelectionViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/6/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationTypeSelectionViewController: WalletGenerationStepViewController, WalletGenerationStep {
    let walletGenerationStepType: WalletGeneration.Step = .setUpNewOrLinkExisting
    weak var walletGenerationStepDelegate: WalletGenerationStepDelegate?
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
    let logoImageView: UIImageView = {
        let image = UIImage(named: "MultiLogo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDescriptionLabelText(text: "Welcome.")
        
        view.addSubview(singleDeviceButton)
        view.addSubview(multiDeviceButton)
        view.addSubview(logoImageView)

        initializeConstraints()
    }
    
    private func initializeConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide

        singleDeviceButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        singleDeviceButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 257).isActive = true

        multiDeviceButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        multiDeviceButton.topAnchor.constraint(equalTo: singleDeviceButton.topAnchor, constant: 60).isActive = true
        
        logoImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -90).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
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
