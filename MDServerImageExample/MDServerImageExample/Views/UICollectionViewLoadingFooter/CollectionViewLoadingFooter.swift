//
//  CollectionViewLoadingFooter.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/6/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

class CollectionViewLoadingFooter: UICollectionReusableView, NibLoadable, Instantiatable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func register(cellTo collectionView: UICollectionView) {
        collectionView.register(CollectionViewLoadingFooter.defaultNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CollectionViewLoadingFooter")
    }
    
}
