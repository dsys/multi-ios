//
//  WalletGenerationPhoneNumberViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/11/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationPhoneNumberViewController: WalletGenerationStepViewController {
    private let phoneNumberTextField: UITextField = {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        let textField = UITextField()
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Phone Number"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        walletGenerationStepType = .enterPhoneNumber
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDescriptionLabelText(text: "Phone")
        self.showsLogoImageView = true
        phoneNumberTextField.delegate = self
        self.informationInputView = phoneNumberTextField
        updateNextButtonEnabled()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        phoneNumberTextField.becomeFirstResponder()
    }
    
    @objc override public func next(button: UIButton?) {
        guard let phoneNumber = phoneNumberTextField.phoneNumber() else { return }
        
        self.isLoading = true
        phoneNumberTextField.resignFirstResponder()
        walletGenerationStepDelegate?.userInputInfo(phoneNumber, forStep: self)
    }
    
    fileprivate func updateNextButtonEnabled() {
        isNextButtonEnabled = phoneNumberTextField.phoneNumber()!.count >= 10
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
        if isNextButtonEnabled {
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

fileprivate extension UITextField {
    func phoneNumber() -> String? {
        return self.text?.numbersOnly()
    }
}
