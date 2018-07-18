//
//  WalletGenerationStepViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/13/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class WalletGenerationStepViewController: UIViewController {
    weak public var walletGenerationStepDelegate: WalletGenerationStepDelegate?
    public var walletGenerationStepType: WalletGeneration.Step?
    public let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.font = UIFont.systemFont(ofSize: 42, weight: .heavy)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    public var informationInputView: UIView? {
        didSet {
            guard let informationInputView = informationInputView else { return }
            view.addSubview(informationInputView)
            view.addSubview(additionalInfoLabel)
            view.addSubview(nextButton)
            view.addSubview(activityIndicatorView)
            initializeInformationInputViewConstraints()
        }
    }
    public var showsLogoImageView: Bool = false {
        didSet {
            if showsLogoImageView {
                view.addSubview(logoImageView)
                initializeLogoImageViewConstraints()
            } else {
                logoImageView.removeFromSuperview()
            }
        }
    }
    public var isNextButtonEnabled: Bool = true {
        didSet {
            nextButton.isEnabled = isNextButtonEnabled
        }
    }
    public var isLoading: Bool = false {
        didSet {
            self.navigationController?.navigationBar.isUserInteractionEnabled = !isLoading
            nextButton.isHidden = isLoading
            nextButton.isEnabled = !isLoading
            if isLoading {
                self.activityIndicatorView.startAnimating()
            } else {
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    public var additionalInfoLabelText: String? {
        didSet {
            UIView.transition(with: additionalInfoLabel, duration: 0.2, options: [ .curveEaseInOut, .transitionCrossDissolve ], animations: {
                self.additionalInfoLabel.text = self.additionalInfoLabelText
                self.additionalInfoLabel.sizeToFit()
            }, completion: nil)
        }
    }
    private var  gradientLayer: CAGradientLayer?
    private lazy var additionalInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(next(button:)), for: .primaryActionTriggered)
        nextButton.tintColor = UIColor.white
        nextButton.sizeToFit()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        return nextButton
    }()
    private lazy var logoImageView: UIImageView = {
        let image = UIImage.multiLogoImage
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        gradientLayer = CAGradientLayer.setupBackgroundGradientLayer(frame: view.bounds)
        view.layer.addSublayer(gradientLayer!)
        
        view.addSubview(descriptionLabel)
        
        initializeDescriptionLabelConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer?.frame = view.frame
    }
    
    func setDescriptionLabelText(text: String) {
        descriptionLabel.text = text
        descriptionLabel.sizeToFit()
    }
    
    private func initializeDescriptionLabelConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        
        descriptionLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 40).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 40).isActive = true
    }
    
    private func initializeInformationInputViewConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        guard let informationInputView = informationInputView else { return }
        
        informationInputView.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor).isActive = true
        informationInputView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        informationInputView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        informationInputView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: informationInputView.bottomAnchor, constant: 40).isActive = true
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        
        additionalInfoLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 40).isActive = true
        additionalInfoLabel.bottomAnchor.constraint(equalTo: informationInputView.topAnchor, constant: -10).isActive = true
        additionalInfoLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -40).isActive = true
    }
    
    private func initializeLogoImageViewConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        
        logoImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -90).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
    }
    
    @objc public func next(button: UIButton?) {
        assertionFailure("Must be implemented by a subclass")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
