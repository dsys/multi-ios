//
//  WalletGenerationUsernameViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/13/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationUsernameViewController: WalletGenerationStepViewController, WalletGenerationStep {
    weak var walletGenerationStepDelegate: WalletGenerationStepDelegate?
    let walletGenerationStepType: WalletGeneration.Step = .enterName
    private let usernameTextField: UITextField = {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        let textField = UITextField()
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Username"
        textField.keyboardType = .asciiCapable
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        let size = activityIndicatorView.frame.size
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: size.height)
        return activityIndicatorView
    }()
    private lazy var usernameErrorLabel: UILabel? = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let nextButton: UIButton = {
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.tintColor = UIColor.white
        nextButton.addTarget(self, action: #selector(next(button:)), for: .primaryActionTriggered)
        nextButton.sizeToFit()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setDescriptionLabelText(text: "Username")
        
        usernameTextField.delegate = self
        usernameTextField.rightView = activityIndicatorView

        view.addSubview(usernameErrorLabel!)
        view.addSubview(usernameTextField)
        view.addSubview(nextButton)
        
        initializeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameTextField.becomeFirstResponder()
    }
    
    private func initializeConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        usernameTextField.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        usernameTextField.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 250).isActive = true
        
        usernameErrorLabel?.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        usernameErrorLabel?.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -10).isActive = true
        usernameErrorLabel?.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, constant: -40).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 40).isActive = true
    }
    
    @objc public func next(button: UIButton?) {
        guard let username = usernameTextField.text else { return }

        usernameTextField.resignFirstResponder()
        activityIndicatorView.startAnimating()
        nextButton.isEnabled = false
        APIManager.sharedManager.checkIfUsernameIsValid(name: username, completion: { (isValid, errorString) in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.setUsernameErrorLabelText(errorString)
                if isValid {
                    self.walletGenerationStepDelegate?.stepCompleted(step: self, success: true, info: [ .name : username ])
                }
                self.nextButton.isEnabled = true
            }
        })
    }
    
    private func setUsernameErrorLabelText(_ text: String?) {
        UIView.transition(with: usernameErrorLabel!, duration: 0.2, options: [.curveEaseInOut, .transitionCrossDissolve], animations: {
            self.usernameErrorLabel?.text = text
        }, completion: nil)
    }
}

extension WalletGenerationUsernameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nextButton.isEnabled {
            next(button: nil)
            return true
        }
        
        return false
    }
}
