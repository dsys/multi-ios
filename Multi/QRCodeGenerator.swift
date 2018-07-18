//
//  QRCodeView.swift
//  Multi
//
//  Created by Andrew Gold on 7/16/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import CoreImage
import UIKit

class QRCodeGenerator: NSObject {
    public static func generateQRCodeImage(data: String, size: CGSize) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        filter.setValue(data.data(using: String.Encoding.isoLatin1, allowLossyConversion: false), forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        guard let qrCodeImage = filter.outputImage else { return nil }
        let scaleX = size.width / qrCodeImage.extent.size.width
        let scaleY = size.height / qrCodeImage.extent.size.height
        
        let transformedImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        return UIImage(ciImage: transformedImage)
    }
}
