//
//  IconImages.swift
//  Multi
//
//  Created by Andrew Gold on 7/4/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

extension UIImage {
    
    public static var transactionSentIcon: UIImage? {
        return templateImageNamed(name: "TransactionSentIcon")
    }
    
    public static var transationReceivedIcon: UIImage? {
        return templateImageNamed(name: "TransactionReceivedIcon")
    }
    
    public static var transactionNewContractIcon: UIImage? {
        return templateImageNamed(name: "TransactionNewContractIcon")
    }
    
    public static var multiLogoImage: UIImage? {
        return UIImage(named: "MultiLogo")
    }
    
    public static var cameraIconImage: UIImage? {
        return UIImage(named: "CameraIcon")
    }
    
    private static func templateImageNamed(name: String) -> UIImage? {
        var image = UIImage(named: name)
        image = image?.withRenderingMode(.alwaysTemplate)
        return image
    }
}
