//
//  DAppCollectionViewCell.swift
//  Multi
//
//  Created by Andrew Gold on 7/11/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class DAppCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView?
    var icon: UIImage? {
        set (icon) {
            self.imageView?.image = icon
        }
        get {
            return imageView?.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let contentView = self.contentView
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.blue
        
        imageView = UIImageView(frame: frame)
        imageView?.contentMode = .scaleAspectFill
        contentView.addSubview(imageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = self.bounds
    }
}
