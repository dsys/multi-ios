//
//  MnemonicWalletGenerationViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/2/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class MnemonicWalletGenerationViewController: UIViewController, WalletGenerationStep, UITextFieldDelegate {
    
    let walletGenerationStepType: WalletGeneration.Step = .enterName
    weak var walletGenerationStepDelegate: WalletGenerationStepDelegate?
    private var mnemonic: [String]?
    private var mnemonicCollectionView: MnemonicCollectionView?
    private var instructionLabel: UILabel?
    private var textField: UITextField?
    private var submitButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view
        view?.backgroundColor = UIColor.white
        
        mnemonic = walletGenerationStepDelegate?.getMnemonic(walletCreator: self)
        
        mnemonicCollectionView = MnemonicCollectionView(mnemonic: mnemonic, frame: view!.bounds)
        mnemonicCollectionView?.backgroundColor = UIColor.white
        mnemonicCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        view?.addSubview(mnemonicCollectionView!)
        
        instructionLabel = UILabel()
        instructionLabel?.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel?.text = "Please enter a name for your wallet:"
        instructionLabel?.sizeToFit()
        view?.addSubview(instructionLabel!)
        
        textField = UITextField()
        textField?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        textField?.delegate = self
        textField?.backgroundColor = UIColor.lightGray
        textField?.translatesAutoresizingMaskIntoConstraints = false
        view?.addSubview(textField!)
        
        submitButton = UIButton(type: .system)
        submitButton?.translatesAutoresizingMaskIntoConstraints = false
        submitButton?.setTitle("Next", for: .normal)
        submitButton?.addTarget(self, action: #selector(submit(sender:)), for: .primaryActionTriggered)
        submitButton?.sizeToFit()
        submitButton?.isEnabled = false
        view?.addSubview(submitButton!)
        
        initializeContraints()
    }
    
    private func initializeContraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        instructionLabel?.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        instructionLabel?.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 50).isActive = true
        
        textField?.widthAnchor.constraint(equalTo: instructionLabel!.widthAnchor).isActive = true
        textField?.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        textField?.topAnchor.constraint(equalTo: instructionLabel!.bottomAnchor, constant: 50).isActive = true
        
        mnemonicCollectionView?.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 1, constant: -100).isActive = true
        mnemonicCollectionView?.heightAnchor.constraint(equalTo: mnemonicCollectionView!.widthAnchor, multiplier: 1, constant: 0).isActive = true
        mnemonicCollectionView?.topAnchor.constraint(equalTo: textField!.topAnchor, constant: 50).isActive = true
        mnemonicCollectionView?.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        
        submitButton?.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        submitButton?.topAnchor.constraint(equalTo: mnemonicCollectionView!.bottomAnchor, constant: 50).isActive = true
    }
    
    @objc private func submit(sender: UIButton) {
        guard let name = textField?.text,
            let mnemonic = self.mnemonic else {
            return
        }
            
        walletGenerationStepDelegate?.stepCompleted(step: self, success: true, info: [ .name: name,
                                                                                      .mnemonic: mnemonic ])
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        guard let count = textField.text?.count else {
            assertionFailure()
            return
        }
        
        submitButton?.isEnabled = count > 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
