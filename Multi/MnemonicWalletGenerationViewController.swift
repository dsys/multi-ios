//
//  MnemonicWalletGenerationViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/2/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class MnemonicWalletGenerationViewController: UIViewController, WalletGenerationStep {
    
    let walletGenerationStepType: WalletGeneration.Step = .enterPassphrase
    weak var walletGenerationStepDelegate: WalletGenerationStepDelegate?
    private let mnemonic: [String]
    private var mnemonicCollectionView: MnemonicCollectionView?
    private var instructionLabel: UILabel?
    private var submitButton: UIButton?
    
    init(mnemonic: [String]) {
        self.mnemonic = mnemonic
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view
        view?.backgroundColor = UIColor.white
        
        mnemonicCollectionView = MnemonicCollectionView(mnemonic: mnemonic, frame: view!.bounds)
        mnemonicCollectionView?.backgroundColor = UIColor.white
        mnemonicCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        view?.addSubview(mnemonicCollectionView!)
        
        instructionLabel = UILabel()
        instructionLabel?.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel?.text = "Remember your mnemonic"
        instructionLabel?.sizeToFit()
        view?.addSubview(instructionLabel!)
        
        submitButton = UIButton(type: .system)
        submitButton?.translatesAutoresizingMaskIntoConstraints = false
        submitButton?.setTitle("Next", for: .normal)
        submitButton?.addTarget(self, action: #selector(submit(sender:)), for: .primaryActionTriggered)
        submitButton?.sizeToFit()
        view?.addSubview(submitButton!)
        
        initializeContraints()
    }
    
    private func initializeContraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        instructionLabel?.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        instructionLabel?.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 50).isActive = true
        
        mnemonicCollectionView?.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 1, constant: -100).isActive = true
        mnemonicCollectionView?.heightAnchor.constraint(equalTo: mnemonicCollectionView!.widthAnchor, multiplier: 1, constant: 0).isActive = true
        mnemonicCollectionView?.topAnchor.constraint(equalTo: instructionLabel!.bottomAnchor, constant: 50).isActive = true
        mnemonicCollectionView?.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        
        submitButton?.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        submitButton?.topAnchor.constraint(equalTo: mnemonicCollectionView!.bottomAnchor, constant: 50).isActive = true
    }
    
    @objc private func submit(sender: UIButton) { 
        walletGenerationStepDelegate?.stepCompleted(step: self, success: true, info: nil)
    }
}
