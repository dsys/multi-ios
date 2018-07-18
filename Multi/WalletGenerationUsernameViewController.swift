//
//  WalletGenerationUsernameViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/13/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationUsernameViewController: WalletGenerationStepViewController {
    private let usernameTextField: UITextField = {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        let textField = UITextField()
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Username"
        textField.keyboardType = .asciiCapable
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        walletGenerationStepType = .enterName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDescriptionLabelText(text: "Username")
        self.showsLogoImageView = true
        
        usernameTextField.delegate = self
        self.informationInputView = usernameTextField
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameTextField.becomeFirstResponder()
    }
    
    @objc override public func next(button: UIButton?) {
        guard let username = usernameTextField.text else { return }

        self.isLoading = true
        usernameTextField.resignFirstResponder()
        walletGenerationStepDelegate?.userInputInfo(username, forStep: self)
    }
}

extension WalletGenerationUsernameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isNextButtonEnabled {
            next(button: nil)
            return true
        }
        
        return false
    }
}
