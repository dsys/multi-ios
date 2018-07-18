//
//  WalletGenerationCreatingIdentityViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/16/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationCreatingIdentityViewController: WalletGenerationStepViewController {
    private let setupType: WalletGeneration.SetupType
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    init(setupType: WalletGeneration.SetupType) {
        self.setupType = setupType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.numberOfLines = 2
        switch setupType {
        case .setUpNewAccount:
            setDescriptionLabelText(text: "Creating\nyour identity")
        case .linkExistingAccount:
            setDescriptionLabelText(text: "Linking\nyour identity")
        }
        
        let layoutGuide = view.safeAreaLayoutGuide
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.startAnimating()
    }
}
