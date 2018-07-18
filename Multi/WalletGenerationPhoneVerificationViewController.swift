//
//  WalletGenerationPhoneVerificationViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/13/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationPhoneVerificationViewController: WalletGenerationStepViewController {
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
        stackView.layoutMargins = UIEdgeInsetsMake(0, 30, 0, 30)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let didNotReceiveACodeButton: UIButton = {
        let didNotReceiveACodeButton = UIButton(type: .system)
        didNotReceiveACodeButton.setTitle("Didn't receive a code?", for: .normal)
        didNotReceiveACodeButton.tintColor = UIColor.white
        didNotReceiveACodeButton.addTarget(self, action: #selector(didNotReceiveACode(button:)), for: .primaryActionTriggered)
        didNotReceiveACodeButton.sizeToFit()
        didNotReceiveACodeButton.translatesAutoresizingMaskIntoConstraints = false
        return didNotReceiveACodeButton
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        walletGenerationStepType = .enterPhoneNumberVerification
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDescriptionLabelText(text: "Verify")
        self.showsLogoImageView = true
        
        configureStackView()
        self.informationInputView = stackView
        
        view.addSubview(didNotReceiveACodeButton)
        view.addSubview(masterTextField)
        updateNextButtonEnabled()
        initializeDidNotReceiveCodeButtonConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        masterTextField.becomeFirstResponder()
    }
    
    private func configureStackView() {
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
    }
    
    private func initializeDidNotReceiveCodeButtonConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        
        didNotReceiveACodeButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        didNotReceiveACodeButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
    }
    
    private static func verificationCodeDigitTextField() -> UITextField {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.white
        textField.translatesAutoresizingMaskIntoConstraints = true
        return textField
    }
    
    @objc public override func next(button: UIButton?) {
        guard let verificationCode = masterTextField.text?.numbersOnly() else { return }
        
        self.isLoading = true
        masterTextField.resignFirstResponder()
        walletGenerationStepDelegate?.userInputInfo(verificationCode, forStep: self)
    }
    
    fileprivate func updateNextButtonEnabled() {
        isNextButtonEnabled = masterTextField.text?.numbersOnly().count == 6
    }
    
    @objc public func didNotReceiveACode(button: UIButton?) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension WalletGenerationPhoneVerificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isNextButtonEnabled {
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
        if textField != masterTextField { return false }
        
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
        
        isNextButtonEnabled = newString.count == 6
        return true
    }
}
