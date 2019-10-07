//
//  AsyncCache.swift
//  MDServerImage
//
//  Created by Shubham on 10/3/19.
//

import UIKit

//enum DataFormat {
//    case png
//    case jpeg(compressionQuality: CGFloat)
//}

class AsyncCache {
    private let memoryCache = NSCache<NSString, AysncCacheItem>()
    private let diskCacheUrl: URL
    private let syncQueue = DispatchQueue(label: "dataCache")
    
    var cacheCleanupDays = 30
    
    init(name: String) throws {
        memoryCache.totalCostLimit = 32 * 1024 * 1024
        
        guard let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            throw NSError(domain: "Cache", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to create disk cache directory"])
        }
        
        diskCacheUrl = URL(fileURLWithPath: cachesPath).appendingPathComponent("cache-\(name)")
        if !FileManager.default.fileExists(atPath: diskCacheUrl.path) {
            try FileManager.default.createDirectory(at: diskCacheUrl, withIntermediateDirectories: true, attributes: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(clear), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    public func save(data: Data, forKey key: String, callbackQueue: DispatchQueue = DispatchQueue.main, completion: (() -> ())? = nil) {
        syncQueue.async {
            let item = AysncCacheItem(data: data)
            
            self.memoryCache.setObject(item, forKey: key as NSString, cost: data.count)
            
            let url = self.diskCacheUrl.appendingPathComponent(key)
            
            do {
                try data.write(to: url, options: .atomic)
            } catch {
                print(error)
            }
            
            callbackQueue.async {
                completion?()
            }
        }
    }
    
    public func get(itemWithKey key: String, callbackQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (_ item: AysncCacheItem?) -> ()) {
        syncQueue.async {
            let url = self.diskCacheUrl.appendingPathComponent(key)
            
            if let item = self.memoryCache.object(forKey: key as NSString) { // memory cache hit
                item.lastUsed = Date()
                callbackQueue.async {
                    completion(item)
                }
                
                try? (url as NSURL).setResourceValue(item.lastUsed, forKey: URLResourceKey.contentAccessDateKey)
            } else {
                do {
                    // try to load from disk cache
                    
                    // get file creation date
                    let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
                    let created = attributes[FileAttributeKey.creationDate] as? Date
                    
                    // load image data
                    let data = try Data(contentsOf: url)
                    
                    // create a new cache item
                    let item = AysncCacheItem(data: data, created: created)
                    
                    // update memory cache
                    self.memoryCache.setObject(item, forKey: key as NSString, cost: data.count)
                    
                    callbackQueue.async {
                        completion(item)
                    }
                    
                    try? (url as NSURL).setResourceValue(item.lastUsed, forKey: URLResourceKey.contentAccessDateKey)
                } catch { // cache miss
                    callbackQueue.async {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    @objc func clear() {
        
        syncQueue.sync {
            memoryCache.removeAllObjects()
            
            do {
                let filesArray = try FileManager.default.contentsOfDirectory(atPath: diskCacheUrl.path)
                let now = Date()
                for file in filesArray {
                    let url = diskCacheUrl.appendingPathComponent(file)
                    var lastAccess: AnyObject?
                    do {
                        try (url as NSURL).getResourceValue(&lastAccess, forKey: URLResourceKey.contentAccessDateKey)
                        if let lastAccess = lastAccess as? Date {
                            if now.timeIntervalSince(lastAccess) > TimeInterval(cacheCleanupDays * 24 * 3600) {
                                try FileManager.default.removeItem(at: url)
                            }
                        }
                    } catch {
                        continue
                    }
                    
                }
            } catch {}
        }
    }
    
    // MARK: - deinit remove ovserver and clean
    deinit {
        NotificationCenter.default.removeObserver(self)
        clear()
    }

}
