//
//  MnemonicCollectionView.swift
//  Multi
//
//  Created by Andrew Gold on 7/3/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

class MnemonicCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    private let cellReuseIdentifier = "MnemonicCollectionViewCellReuseIdentifier"
    private var mnemonic: [String]!
    private var collectionView: UICollectionView!

    init(mnemonic: [String]?, frame: CGRect) {
        super.init(frame: frame)
        self.mnemonic = mnemonic
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: 75, height: 75)
        collectionViewLayout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        collectionView.register(MnemonicCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mnemonic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! MnemonicCollectionViewCell
        cell.word = mnemonic[indexPath.row]
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
