//
//  Image.swift
//  Pods-MDServerImageExample
//
//  Created by Shubham Bairagi on 02/10/19.
//

import UIKit

public enum DownloadCompletionType {
    case canceled
    case error(error: NSError)
    case success(data: Data)
}

public enum DataCompletionType {
    case canceledOrInvalidated
    case error(error: NSError)
    case data(data: Data)
}

public class MDServerImage {
    /// The shared instance of MDServerImage for convenience
    public static let sharedInstance = MDServerImage(identifier: "default")

    /// The timeout interval to use when downloading images
    public var timeoutInterval = 30.0
    public var cacheStaleInterval = 30.0
    private let operationQueue = OperationQueue()
    
    let cache: AsyncCache
    
    private lazy var keyCache: NSCache<NSString, NSString> = {
        var cache = NSCache<NSString, NSString>()
        cache.countLimit = 100
        return cache
    }()
    
    // MARK: - Constructor
    /**
     Creates a new MDServerImage instance with identifier.
     
     - parameter identifier: The identifier for this instance. This is used for disk caching.
     */
    public init(identifier: String) {
        cache = try! AsyncCache(name: identifier)
    }
    
    // MARK: - Public methods
    public func downloadData(fromUrl url: URL, requestModification: ((_ request: URLRequest) -> URLRequest)? = nil, customIdentifier: String? = nil, completion: ((_ result: DownloadCompletionType, _ invalidated: Bool) -> ())?) {
        
        let identifier: String = customIdentifier ?? UUID().uuidString
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        
        // set headers
        request.addValue("image/*, */*; q=0.5", forHTTPHeaderField: "Accept")
        
        if let closure = requestModification {
            request = closure(request)
        }
        
        let operation = MDServerImageOperation(urlRequest: request, identifier: identifier, callbackQueue: DispatchQueue.main, downloadFinishedBlock: { operation, result in
            
            switch result {
            case .canceled:
                completion?(.canceled, operation.invalidated)
            case .error(let error):
                completion?(.error(error: error as NSError), operation.invalidated)
            case .success(let data):
                completion?(.success(data: data), operation.invalidated)
            }
        })
        
        operationQueue.addOperation(operation)
    }

    public func getData(fromUrl url: URL, requestModification: ((_ request: URLRequest) -> URLRequest)? = nil, customIdentifier: String? = nil, completion: ((_ result: DataCompletionType) -> ())?) {
        let cacheKey = transformUrlToCacheKey(url)
        
        let downloadAction = { (cachePolicy: NSURLRequest.CachePolicy) -> () in
           
            self.downloadData(fromUrl: url, requestModification: requestModification, customIdentifier: customIdentifier, completion: { completionType, invalidated in
                
                if invalidated {
                    completion?(.canceledOrInvalidated)
                } else {
                    switch completionType {
                    case .canceled:
                        completion?(.canceledOrInvalidated)
                    case .error(let error):
                        completion?(.error(error: error))
                    case .success(let data):
                        self.cache.save(data: data, forKey: cacheKey, callbackQueue: DispatchQueue.main, completion: {
                            completion?(.data(data: data))
                        })
                    }
                }
            })
        }
        
        cache.get(itemWithKey: cacheKey) { item in
            if let item = item,
                Date().timeIntervalSince(item.created) < self.cacheStaleInterval {
                completion?(.data(data: item.data))
            } else {
                downloadAction(.useProtocolCachePolicy)
            }
        }
    }
    
    public func cancelDownload(identifier: String?) {
        guard let identifier = identifier else { return }
        
        for operation in operationQueue.operations {
            if let operation = operation as? MDServerImageOperation, operation.identifier == identifier {
                operation.cancel()
            }
        }
    }
    
    public func invalidateDownload(identifier: String?) {
        guard let identifier = identifier else { return }
        
        for operation in operationQueue.operations {
            if let operation = operation as? MDServerImageOperation, operation.identifier == identifier {
                operation.invalidated = true
            }
        }
    }
    
    private func transformUrlToCacheKey(_ url: URL) -> String {
        let urlString = url.absoluteString
        
        if let key = keyCache.object(forKey: urlString as NSString) as String? {
            return key
        } else {
            return urlString.md5digest()
        }
    }
}

