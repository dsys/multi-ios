//
//  QRCodeGeneratorTest.swift
//  MultiTests
//
//  Created by Andrew Gold on 7/16/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit
import XCTest
@testable import Multi

class QRCodeGeneratorTest: XCTestCase {
#if !targetEnvironment(simulator)
    func testGenerateQRCode() {
        let image = QRCodeGenerator.generateQRCodeImage(data: "This is a test", size: CGSize(width: 100, height: 100))
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [ CIDetectorAccuracy: CIDetectorAccuracyHigh ])
        
        let features = detector!.features(in: image!.ciImage!)
        for feature in features {
            XCTAssertEqual((feature as! CIQRCodeFeature).messageString, string)
        }
    }
#endif
}
