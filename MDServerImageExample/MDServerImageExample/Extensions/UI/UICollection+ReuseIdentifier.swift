//
//  UITableView+ReuseIdentifier.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
