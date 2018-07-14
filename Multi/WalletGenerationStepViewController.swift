//
//  WalletGenerationStepViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/13/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationStepViewController: UIViewController {
    private var gradientLayer: CAGradientLayer?
    private var descriptionLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        gradientLayer = CAGradientLayer.setupBackgroundGradientLayer(frame: view.bounds)
        view.layer.addSublayer(gradientLayer!)
        
        descriptionLabel = UILabel()
        descriptionLabel?.textColor = UIColor.white
        descriptionLabel?.font = UIFont.systemFont(ofSize: 42, weight: .heavy)
        descriptionLabel?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel!)
        
        initializeDescriptionLabelConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer?.frame = view.frame
    }
    
    func setDescriptionLabelText(text: String) {
        descriptionLabel?.text = text
        descriptionLabel?.sizeToFit()
    }
    
    private func initializeDescriptionLabelConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        
        descriptionLabel?.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 120).isActive = true
        descriptionLabel?.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 40).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
