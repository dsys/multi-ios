//
//  GradientLayer.swift
//  Multi
//
//  Created by Andrew Gold on 7/13/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    public static func setupBackgroundGradientLayer(frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [ UIColor(displayP3Red: 110.0/255.0, green: 172.0/255.0, blue: 242.0/255.0, alpha: 1).cgColor, UIColor(displayP3Red: 85.0/255.0, green: 110.0/255.0, blue: 248.0/255.0, alpha: 1).cgColor ]
        return gradientLayer
    }
}
