//
//  WalletGenerationPhoneVerificationViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/13/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationPhoneVerificationViewController: WalletGenerationStepViewController, WalletGenerationStep {
    weak var walletGenerationStepDelegate: WalletGenerationStepDelegate?
    let walletGenerationStepType: WalletGeneration.Step = .enterPhoneNumberVerification
    private let digit1TextField: UITextField = verificationCodeDigitTextField()
    private let digit2TextField: UITextField = verificationCodeDigitTextField()
    private let digit3TextField: UITextField = verificationCodeDigitTextField()
    private let digit4TextField: UITextField = verificationCodeDigitTextField()
    private let digit5TextField: UITextField = verificationCodeDigitTextField()
    private let digit6TextField: UITextField = verificationCodeDigitTextField()
    private let masterTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.keyboardType = .numberPad
        return textField
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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

        setDescriptionLabelText(text: "Verify")
        
        stackView.addArrangedSubview(digit1TextField)
        stackView.addArrangedSubview(digit2TextField)
        stackView.addArrangedSubview(digit3TextField)
        stackView.addArrangedSubview(digit4TextField)
        stackView.addArrangedSubview(digit5TextField)
        stackView.addArrangedSubview(digit6TextField)
        
        masterTextField.delegate = self
        for textField in stackView.arrangedSubviews {
            (textField as! UITextField).delegate = self
        }
        
        view.addSubview(stackView)
        view.addSubview(nextButton)
        view.addSubview(masterTextField)
        
        initializeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        masterTextField.becomeFirstResponder()
    }
    
    private func initializeConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        
        stackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        stackView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 35).isActive = true
        stackView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 250).isActive = true
        stackView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -35).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40).isActive = true
    }
    
    private static func verificationCodeDigitTextField() -> UITextField {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.white
        textField.translatesAutoresizingMaskIntoConstraints = true
        return textField
    }
    
    @objc public func next(button: UIButton?) {
        
    }
}

extension WalletGenerationPhoneVerificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nextButton.isEnabled {
            next(button: nil)
            return true
        }
        
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == masterTextField {
            return true
        }
        
        masterTextField.becomeFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == masterTextField {
            guard let oldString = textField.text else { return true }
            let newString = (oldString as NSString).replacingCharacters(in: range, with: string)
            let count = newString.count
            if count > 6 {
                return false
            }
            
            var textFields = stackView.arrangedSubviews
            for i in 0..<count {
                let field = textFields.removeFirst() as! UITextField
                field.text = String(newString[newString.index(newString.startIndex, offsetBy: i)])
            }
            
            for textField in textFields {
                (textField as! UITextField).text = ""
            }
            
            
            return true
        }
        
        return false
    }
}
