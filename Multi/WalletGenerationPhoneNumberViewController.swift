//
//  WalletGenerationPhoneNumberViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/11/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationPhoneNumberViewController: WalletGenerationInfoViewController {

    init() {
        super.init(walletGenerationStepType: .enterPhoneNumber, walletGenerationInfo: .phoneNumber, labelString: "Enter Phone Number:")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        textField.keyboardType = .phonePad
        textField.placeholder = "Phone"
        
        nextButton.isEnabled = false
    }
    
    @objc override public func next(button: UIButton) {
        guard let phoneNumber = textField.phoneNumber() else { return }
        APIManager.sharedManager.sendPhoneNumberForVerification(phoneNumber: phoneNumber) { (success) in
            DispatchQueue.main.async {
                if success {
                    self.walletGenerationStepDelegate?.stepCompleted(step: self, success: true, info: [ self.walletGenerationInfo : phoneNumber ])
                }
            }
        }
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldString = textField.text else { return true }
        let newString = (oldString as NSString).replacingCharacters(in: range, with: string)
        let text = formattedPhoneNumber(newString)
        textField.text = formattedPhoneNumber(newString)
        nextButton.isEnabled = text.numbersOnly().count >= 7
        
        return false
    }
}

extension UITextField {
    func phoneNumber() -> String? {
        return self.text?.numbersOnly()
    }
}

extension String {
    func numbersOnly() -> String {
        return self.filter { (character) -> Bool in
            return character >= "0" && character <= "9"
        }
    }
}
