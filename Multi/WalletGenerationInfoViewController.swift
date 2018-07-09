//
//  WalletCreationInfoViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/6/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationInfoViewController: UIViewController, WalletGenerationStep, UITextFieldDelegate {
    
    weak var walletGenerationStepDelegate: WalletGenerationStepDelegate?
    let walletGenerationStepType: WalletGeneration.Step
    let walletGenerationInfo: WalletGeneration.Info
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let textField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        textField.backgroundColor = UIColor.lightGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    let nextButton: UIButton = {
        let nextButton = UIButton(type: .system)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(next(button:)), for: .primaryActionTriggered)
        nextButton.sizeToFit()
        nextButton.isEnabled = false
        return nextButton
    }()
    
    init(walletGenerationStepType: WalletGeneration.Step, walletGenerationInfo: WalletGeneration.Info, labelString: String) {
        self.walletGenerationStepType = walletGenerationStepType
        self.walletGenerationInfo = walletGenerationInfo
        super.init(nibName: nil, bundle: nil)
        
        label.text = labelString
        textField.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let view = self.view
        view?.backgroundColor = UIColor.white
        
        view?.addSubview(label)
        view?.addSubview(textField)
        view?.addSubview(nextButton)
        
        label.sizeToFit()
        initializeConstraints()
    }
    
    private func initializeConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        label.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 100).isActive = true
        label.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        
        textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50).isActive = true
        textField.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        nextButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        guard let count = textField.text?.count else {
            assertionFailure()
            return
        }
        
        nextButton.isEnabled = count > 0
    }
    
    @objc private func next(button: UIButton) {
        walletGenerationStepDelegate?.stepCompleted(step: self, success: true, info: [walletGenerationInfo : textField.text!])
    }
}
