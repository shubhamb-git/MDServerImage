//
//  PinCollectionViewCell.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

class PinCollectionViewCell: UICollectionViewCell, NibLoadable, Instantiatable {

    @IBOutlet weak var pinImageView: UIImageView!

    static func register(cellTo collectionView: UICollectionView) {
        collectionView.register(PinCollectionViewCell.defaultNib, forCellWithReuseIdentifier: PinCollectionViewCell.defaultReuseIdentifier)
    }
    
    static func cell(for collectionView: UICollectionView, at indexPath: IndexPath, withPin pin: PinModel) -> PinCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinCollectionViewCell.defaultReuseIdentifier, for: indexPath) as? PinCollectionViewCell else {
            fatalError("Cell not registered")
        }
        
        cell.pinImageView.setImage(withUrl: pin.urls?.thumb, placeHolder: nil)
        
        return cell
    }
}
