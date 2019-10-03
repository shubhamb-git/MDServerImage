//
//  AysncCacheItem.swift
//  MDServerImage
//
//  Created by Shubham on 10/3/19.
//

import UIKit

class AysncCacheItem {
    var lastUsed: Date
    let created: Date
    let data: Data
    
    init(data: Data, created: Date? = nil) {
        self.data = data
        let now = Date()
        self.lastUsed = now
        self.created = created ?? now
    }
}
