//
//  UIImageView+Extension.swift
//  MDServerImage
//
//  Created by Shubham on 10/3/19.
//

import UIKit

public protocol MDServerURL {
    var toUrl: URL? { get }
}
extension URL: MDServerURL {
    public var toUrl: URL? { return self }
}
extension String: MDServerURL {
    public var toUrl: URL? { return URL(string: self) }
}

fileprivate var handlerKey = "handler"
extension UIImageView {

    var imageViewHandler: MDServerImageViewHandler {
        if let obj = objc_getAssociatedObject(self, &handlerKey) as? MDServerImageViewHandler {
            return obj
        } else {
            let obj = MDServerImageViewHandler()
            objc_setAssociatedObject(self, &handlerKey, obj, .OBJC_ASSOCIATION_RETAIN)
            return obj
        }
    }
    
    public func cancelImageDownload() {
        imageViewHandler.cancel()
    }
    
    public func invalidateImageDownload() {
        imageViewHandler.invalidate()
    }
    
    public func setImage(withUrl url: MDServerURL, placeholder: UIImage? = nil, requestModification: ((_ request: URLRequest) -> URLRequest)? = nil, completion: ((_ result: DataCompletionType) -> ())? = nil) {
        
        if let placeholder = placeholder {
            image = placeholder
        } else {
            image = nil
        }
        imageViewHandler.load(url: url.toUrl, requestModification: requestModification) { [weak self] result in
            
            if case .data(let data) = result {
                self?.image = UIImage(data: data)
            }
            completion?(result)
        }
    }
}
