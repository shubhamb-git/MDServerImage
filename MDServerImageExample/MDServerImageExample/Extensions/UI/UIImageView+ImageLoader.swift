//
//  UIImageView+ImageLoader.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit
import MDServerImage

extension UIImageView {
    
    func setImage(withUrl url: String?, placeHolder: UIImage? = nil, completed: ((_ result: DataCompletionType) -> ())? = nil) {
        guard let url = url else {
            self.image = placeHolder
            return
        }
        self.setImage(withUrl: url, placeholder: placeHolder, completion: completed)
    }
}
