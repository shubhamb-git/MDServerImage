//
//  UIImageView+ImageLoader.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit
import MDServerImage

enum ImageCompletionType {
    case error(errorMessage: String)
    case image(image: UIImage?)
}
extension UIImageView {
    
    func setImage(withUrl url: String?, placeHolder: UIImage? = nil, completed: ((_ result: ImageCompletionType) -> ())? = nil) {
        guard let url = url else {
            self.image = placeHolder
            completed?(.error(errorMessage: "URL Not found"))
            return
        }
        self.setImage(withUrl: url, placeholder: placeHolder) { (completionType) in
            switch completionType {
            case .canceledOrInvalidated:
                completed?(.error(errorMessage: "Operation cancelled by user"))
            case .data(let data):
                completed?(.image(image: UIImage(data: data)))
            case .error(let error):
                completed?(.error(errorMessage: error.localizedDescription))
            }
        }
    }
}
