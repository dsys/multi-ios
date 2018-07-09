//
//  MnemonicCollectionViewCell.swift
//  Multi
//
//  Created by Andrew Gold on 7/4/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class MnemonicCollectionViewCell: UICollectionViewCell {
    
    private var wordLabel: UILabel?
    public var word: String? {
        set(word) {
            self.wordLabel?.text = word
        }
        get {
            return self.wordLabel?.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        wordLabel = UILabel(frame: frame)
        wordLabel?.textAlignment = .center
        self.contentView.addSubview(wordLabel!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wordLabel?.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
