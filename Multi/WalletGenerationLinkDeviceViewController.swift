//
//  MultiDeviceWalletGenerationDevicePairingViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/5/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import AVFoundation
import UIKit

class WalletGenerationLinkDeviceViewController: UIViewController, WalletGenerationStep {
    
    let walletGenerationStepType: WalletGeneration.Step = .linkOtherDevice
    weak var walletGenerationStepDelegate: WalletGenerationStepDelegate?
    private let setupType: WalletGeneration.SetupType
    var cameraPreview: UIView?
    let qrLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var dontHaveAnotherDeviceButton: UIButton?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    init(setupType: WalletGeneration.SetupType) {
        self.setupType = setupType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let view = self.view
        view?.backgroundColor = UIColor.white
        
        cameraPreview = UIView()
        cameraPreview?.translatesAutoresizingMaskIntoConstraints = false
        cameraPreview?.backgroundColor = UIColor.blue
        view?.addSubview(cameraPreview!)
        
        view?.addSubview(qrLabel)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(gestureRecognizer:)))
        cameraPreview?.addGestureRecognizer(gestureRecognizer)
        
        if setupType == .setUpNewAccount {
            dontHaveAnotherDeviceButton = UIButton(type: .system)
            dontHaveAnotherDeviceButton?.translatesAutoresizingMaskIntoConstraints = false
            dontHaveAnotherDeviceButton?.setTitle("Don't have another device handy?", for: .normal)
            dontHaveAnotherDeviceButton?.addTarget(self, action: #selector(dontHaveAnotherDeviceButtonTapped(button:)), for: .primaryActionTriggered)
            dontHaveAnotherDeviceButton?.sizeToFit()
            view?.addSubview(dontHaveAnotherDeviceButton!)
        }
        
        initializeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startStreamingVideo()
    }
    
    private func initializeConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        cameraPreview?.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 50).isActive = true
        cameraPreview?.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 50).isActive = true
        cameraPreview?.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -50).isActive = true
        cameraPreview?.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        qrLabel.topAnchor.constraint(equalTo: cameraPreview!.bottomAnchor, constant: 50).isActive = true
        qrLabel.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        
        if setupType == .setUpNewAccount {
            dontHaveAnotherDeviceButton?.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
            dontHaveAnotherDeviceButton?.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -50).isActive = true
        }
    }
    
    @objc private func tapped(gestureRecognizer: UITapGestureRecognizer) {
        walletGenerationStepDelegate?.stepCompleted(step: self, success: true, info: nil)
    }
    
    @objc private func dontHaveAnotherDeviceButtonTapped(button: UIButton) {
        walletGenerationStepDelegate?.stepCompleted(step: self, success: false, info: nil)
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
        videoPreviewLayer?.frame = cameraPreview!.bounds
        cameraPreview?.layer.addSublayer(videoPreviewLayer!)
        
        captureSession?.startRunning()
    }
}

extension WalletGenerationLinkDeviceViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadataObject in metadataObjects {
            if metadataObject.type == .qr {
                DispatchQueue.main.async {
                    self.qrLabel.text = (metadataObject as! AVMetadataMachineReadableCodeObject).stringValue
                    self.qrLabel.sizeToFit()
                }
            }
        }
    }
}
