//
//  WalletGenerationPassphraseViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/16/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationPassphraseViewController: WalletGenerationStepViewController {
    private let passphraseTextField: UITextField = {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        let textField = UITextField()
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Passphrase"
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private var passphrase: String?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        walletGenerationStepType = .enterPassphrase
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setDescriptionLabelText(text: "Passphrase")
        self.additionalInfoLabelText = "Enter a passphrase"
        self.showsLogoImageView = true
        
        passphraseTextField.delegate = self
        self.informationInputView = passphraseTextField
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        passphraseTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        passphrase = nil
        passphraseTextField.text = nil
        self.additionalInfoLabelText = nil
    }
    
    @objc override public func next(button: UIButton?) {
        guard let text = passphraseTextField.text else { return }
        if let passphrase = passphrase {
            if text == passphrase {
                self.walletGenerationStepDelegate?.userInputInfo(passphrase, forStep: self)
            } else {
                self.additionalInfoLabelText = "Passphrase does not match"
                passphraseTextField.text = nil
                self.passphrase = nil
            }
        } else {
            self.additionalInfoLabelText = "Confirm your passphrase"
            passphrase = text
            passphraseTextField.text = ""
        }
    }
}

extension WalletGenerationPassphraseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isNextButtonEnabled {
            next(button: nil)
            return true
        }
        
        return false
    }
}
