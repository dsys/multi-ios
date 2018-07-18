//
//  MultiDeviceWalletGenerationDevicePairingViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/5/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import AVFoundation
import UIKit

class CameraPreviewView: UIView {
    private let iconImageView: UIImageView = {
        let cameraIconImage = UIImage.cameraIconImage
        let iconImageView = UIImageView(image: cameraIconImage)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(displayP3Red: 199.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white
        addSubview(iconImageView)
        
        initializeIconImageViewConstraints()
    }
    
    private func initializeIconImageViewConstraints() {
        let layoutGuide = self.safeAreaLayoutGuide
        
        iconImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive =  true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WalletGenerationLinkDeviceViewController: WalletGenerationStepViewController {
    private let setupType: WalletGeneration.SetupType
    private let containerView: UIView = {
        let view = UIView()
        let layer = view.layer
        layer.cornerRadius = 8
        layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var cameraPreview: CameraPreviewView = CameraPreviewView()
    private var qrImageView: UIImageView = {
        let imageView = UIImageView()
        let layer = imageView.layer
        layer.cornerRadius = 8
        layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let explanationaLabel: UILabel = {
        let label = UILabel()
        var attributedString = NSMutableAttributedString(string: "Open Multi on another device or visit ")
        attributedString.append(NSAttributedString(string: "multiapp.com", attributes: [ .underlineStyle: NSUnderlineStyle.styleSingle.rawValue ]))
        attributedString.append(NSAttributedString(string: " and scan the code that appears after tapping "))
        attributedString.append(NSAttributedString(string: "Link an existing identity.", attributes: [ .font: UIFont.italicSystemFont(ofSize: 17) ]))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var otherButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(otherButtonTapped(button:)), for: .primaryActionTriggered)
        button.sizeToFit()
        return button
    }()
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var isShowingQRCode = false {
        didSet {
            let fromView = isShowingQRCode ? cameraPreview : qrImageView
            let toView = isShowingQRCode ? qrImageView : cameraPreview
            
            if isShowingQRCode && qrImageView.image == nil {
                qrActivityIndicator.startAnimating()
                fetchQRImageIfNeeded { (image) in
                    self.qrActivityIndicator.stopAnimating()
                    self.qrImageView.image = image
                }
            }
            
            UIView.transition(with: containerView, duration: 0.4, options: [ .transitionFlipFromLeft, .curveEaseInOut ], animations: {
                fromView.isHidden = true
                toView.isHidden = false
            }) { _ in
                self.updateOtherButtonText()
                self.videoPreviewLayer!.isHidden = self.isShowingQRCode
            }
        }
    }
    private lazy var qrActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator =  UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    init(setupType: WalletGeneration.SetupType) {
        self.setupType = setupType
        super.init(nibName: nil, bundle: nil)
        walletGenerationStepType = .linkOtherDevice
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDescriptionLabelText(text: "Link")
        updateOtherButtonText()
        
        view.addSubview(containerView)
        containerView.addSubview(qrImageView)
        qrImageView.addSubview(qrActivityIndicator)
        containerView.addSubview(cameraPreview)
        view.addSubview(explanationaLabel)
        view?.addSubview(otherButton)
        
        initializeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startStreamingVideo()
    }
    
    private func initializeConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide

        containerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4).isActive = true
        containerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 30).isActive = true
        containerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -30).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        cameraPreview.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        cameraPreview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        cameraPreview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        cameraPreview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        qrImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        qrImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        qrImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        qrImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        qrActivityIndicator.centerXAnchor.constraint(equalTo: qrImageView.centerXAnchor).isActive = true
        qrActivityIndicator.centerYAnchor.constraint(equalTo: qrImageView.centerYAnchor).isActive = true
        
        explanationaLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10).isActive = true
        explanationaLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 30).isActive = true
        explanationaLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -30).isActive = true
        
        otherButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        otherButton.topAnchor.constraint(greaterThanOrEqualTo: explanationaLabel.bottomAnchor, constant: 10).isActive = true
        otherButton.bottomAnchor.constraint(lessThanOrEqualTo: layoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    private func updateOtherButtonText() {
        var otherButtonText: String
        if setupType == .setUpNewAccount {
            otherButtonText = "Don't have another device handy?"
        } else {
            if isShowingQRCode {
                otherButtonText = "Scan a code"
            } else {
                otherButtonText = "Display a code"
            }
        }
        
        otherButton.setTitle(otherButtonText, for: .normal)
    }
    
    @objc private func otherButtonTapped(button: UIButton) {
        if setupType == .setUpNewAccount {
            walletGenerationStepDelegate?.userInputInfo(nil, forStep: self)
            return
        }
        
        isShowingQRCode = !isShowingQRCode
    }
    
    private func startStreamingVideo() {
        guard let device = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: device)  else {
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue(label: "com.multi.WalletGenerationLinkDeviceViewController"))
        metadataOutput.metadataObjectTypes = [ .qr ]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = cameraPreview.bounds
        cameraPreview.layer.addSublayer(videoPreviewLayer!)
        
        captureSession?.startRunning()
    }
    
    private func fetchQRImageIfNeeded(completion: @escaping (UIImage?) -> Void) {
        APIManager.sharedManager.getDeviceLinkingQRPayload { (payload) in
            DispatchQueue.main.async {
                guard let data = payload else {
                    completion(nil)
                    return
                }
                
                completion(QRCodeGenerator.generateQRCodeImage(data: data, size: self.qrImageView.frame.size))
            }
        }
    }
}

extension WalletGenerationLinkDeviceViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadataObject in metadataObjects {
            if metadataObject.type != .qr { return }
            guard let stringValue = (metadataObject as! AVMetadataMachineReadableCodeObject).stringValue else { return }
            DispatchQueue.main.async {
                self.walletGenerationStepDelegate?.userInputInfo(stringValue, forStep: self)
            }
        }
    }
}
