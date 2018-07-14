//
//  WalletGenerationPhoneNumberViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/11/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationPhoneNumberViewController: WalletGenerationStepViewController, WalletGenerationStep {
    weak var walletGenerationStepDelegate: WalletGenerationStepDelegate?
    let walletGenerationStepType: WalletGeneration.Step = .enterPhoneNumber
    private let phoneNumberTextField: UITextField = {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        let textField = UITextField()
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Phone Number"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        let size = activityIndicatorView.frame.size
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: size.height)
        return activityIndicatorView
    }()
    private lazy var phoneNumberErrorLabel: UILabel? = {
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
        
        setDescriptionLabelText(text: "Phone")
        
        phoneNumberTextField.delegate = self
        phoneNumberTextField.rightView = activityIndicatorView
        
        view.addSubview(phoneNumberErrorLabel!)
        view.addSubview(phoneNumberTextField)
        view.addSubview(nextButton)
        
        initializeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        phoneNumberTextField.becomeFirstResponder()
    }
    
    @objc public func next(button: UIButton?) {
        guard let phoneNumber = phoneNumberTextField.phoneNumber() else { return }
        
        phoneNumberTextField.resignFirstResponder()
        activityIndicatorView.startAnimating()
        nextButton.isEnabled = false
        APIManager.sharedManager.startPhoneNumberVerification(phoneNumber: phoneNumber) { (success, message) in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                if success {
                    self.walletGenerationStepDelegate?.stepCompleted(step: self, success: true, info: [ .phoneNumber : phoneNumber ])
                }
                self.updateNextButtonEnabled()
            }
        }
    }
    
    fileprivate func updateNextButtonEnabled() {
        nextButton.isEnabled = phoneNumberTextField.phoneNumber()!.count >= 10
    }
    
    private func initializeConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        phoneNumberTextField.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor).isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        phoneNumberTextField.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        phoneNumberTextField.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 250).isActive = true
        
        phoneNumberErrorLabel?.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        phoneNumberErrorLabel?.bottomAnchor.constraint(equalTo: phoneNumberTextField.topAnchor, constant: -10).isActive = true
        phoneNumberErrorLabel?.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, constant: -40).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 40).isActive = true
    }

    func formattedPhoneNumber(_ phoneNumber: String) -> String {
        var numberString = phoneNumber.numbersOnly()
        switch numberString.count {
        case 4..<7:
            numberString.insert("-", at: String.Index(encodedOffset: 3))
        case 7..<11:
            numberString.insert("(", at: String.Index(encodedOffset: 0))
            numberString.insert(contentsOf: ") ", at: String.Index(encodedOffset: 4))
            numberString.insert("-", at: String.Index(encodedOffset: 9))
        default:
            break
        }
        
        return numberString
    }
}

extension WalletGenerationPhoneNumberViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nextButton.isEnabled {
            next(button: nil)
            return true
        }
        
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldString = textField.text else { return true }
        let newString = (oldString as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedPhoneNumber(newString)
        updateNextButtonEnabled()
        
        return false
    }
}

extension UITextField {
    func phoneNumber() -> String? {
        return self.text?.numbersOnly()
    }
}
