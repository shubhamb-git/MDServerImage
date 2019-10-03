//
//  MDServerImageViewHandler.swift
//  MDServerImage
//
//  Created by Shubham on 10/3/19.
//

import Foundation

public class MDServerImageViewHandler: NSObject {
    private var downloadIdentifiers = Set<String>()
    
    func cancel() {
        for identifier in downloadIdentifiers {
            MDServerImage.sharedInstance.cancelDownload(identifier: identifier)
        }
        downloadIdentifiers.removeAll()
    }
    
    func invalidate() {
        for identifier in downloadIdentifiers {
            MDServerImage.sharedInstance.invalidateDownload(identifier: identifier)
        }
        downloadIdentifiers.removeAll()
    }
    
    func load(url: URL?, requestModification: ((_ request: URLRequest) -> URLRequest)?, completion: ((_ result: DataCompletionType) -> ())?) {
        
        if let url = url {
            let identifier = UUID().uuidString
            downloadIdentifiers.insert(identifier)
            MDServerImage.sharedInstance.getData(fromUrl: url, requestModification: nil, customIdentifier: identifier, completion: { [weak self] result in
                if self?.downloadIdentifiers.contains(identifier) ?? false {
                    let _ = self?.downloadIdentifiers.remove(identifier)
                    completion?(result)
                } else {
                    completion?(.canceledOrInvalidated)
                }
            })
        }
    }
}
