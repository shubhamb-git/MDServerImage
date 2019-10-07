//
//  CacheTests.swift
//  MDServerImageExampleTests
//
//  Created by Shubham on 10/7/19.
//  Copyright © 2019 sb. All rights reserved.
//

import XCTest
@testable import MDServerImage

class CacheTests: XCTestCase {

    let cache = try! AsyncCache(name: "test-identifier")
    
    override func setUp() {
        super.setUp()
        self.cache.cacheCleanupDays = 0
    }
    
    override func tearDown() {
        cache.clear()
        super.tearDown()
    }
    
    func testSaveCache() {
        print(NSHomeDirectory())
        let e = expectation(description: "Save image")
        
        cache.save(data: MDServerImageTestHelper.sampleImageData!, forKey: "TestImageCache") {
            
            self.cache.get(itemWithKey: "TestImageCache", completion: { (asyncCacheItem) in
                if let asyncCacheItem = asyncCacheItem {
                    XCTAssertEqual(asyncCacheItem.data, MDServerImageTestHelper.sampleImageData!, "Wrong image found")
                } else {
                    XCTAssert(false, "Image not cached")
                }
              
                e.fulfill()
            })
        }
        
        waitForExpectations(timeout: 5.0) { (error: Error?) in
            print("Timeout Error: \(error.debugDescription)")
        }
    }
    
    
    func testClearCache() {
        print(NSHomeDirectory())
        let e = expectation(description: "Save image")
        cache.save(data: MDServerImageTestHelper.sampleImageData!, forKey: "TestImageCache") {
            self.cache.clear()
            
            self.cache.get(itemWithKey: "TestImageCache", completion: { (asyncCacheItem) in
                
                XCTAssert(asyncCacheItem == nil, "Not able to delete image")
                
                e.fulfill()
            })
        }
        
        waitForExpectations(timeout: 20.0) { (error: Error?) in
            print("Timeout Error: \(error.debugDescription)")
        }
    }
}
