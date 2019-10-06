//
//  PinCollectionViewCell.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

class PinCollectionViewCell: UICollectionViewCell, NibLoadable, Instantiatable {

    @IBOutlet weak var pinInfoView: CustomView!
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnLIke: UIButton!
    
    var pin: PinModel! {
        didSet {
            pinImageView.setImage(withUrl: pin.urls?.thumb, placeHolder: nil)
            userImage.setImage(withUrl: pin.user?.profileImage?.small, placeHolder: nil)
            lblUserName.text = pin.user?.name
            btnLIke.isSelected = pin.likedByUser ?? false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pinImageView.setCornerRadius(12)
        userImage.makeCircle()
    }
    
    static func register(cellTo collectionView: UICollectionView) {
        collectionView.register(PinCollectionViewCell.defaultNib, forCellWithReuseIdentifier: PinCollectionViewCell.defaultReuseIdentifier)
    }
    
    static func cell(for collectionView: UICollectionView, at indexPath: IndexPath, withPin pin: PinModel) -> PinCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinCollectionViewCell.defaultReuseIdentifier, for: indexPath) as? PinCollectionViewCell else {
            fatalError("Cell not registered")
        }
        
        cell.pin = pin
        
        return cell
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        pin.like(status: sender.isSelected)
    }
}
