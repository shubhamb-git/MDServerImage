//
//  ImageDownloadTests.swift
//  MDServerImageExampleTests
//
//  Created by Shubham on 10/7/19.
//  Copyright © 2019 sb. All rights reserved.
//

import XCTest
@testable import MDServerImage
@testable import MDServerImageExample

class ImageDownloadTests: XCTestCase {

    var imageView: UIImageView! = UIImageView()
   
    override func tearDown() {
        imageView = nil
        super.tearDown()
    }
    
    func testImageDownloader() {
        let e = expectation(description: "Load Image")
        
        imageView.setImage(withUrl: MDServerImageTestHelper.imageUrl, placeholder: nil) { (completionType) in
            switch completionType {
            case .canceledOrInvalidated:
                XCTAssert(false, "Response is wrong.")
            case .data(let imgData):
                XCTAssertEqual(String(data: imgData, encoding: .utf8), String(data: MDServerImageTestHelper.sampleImageData!, encoding: .utf8), "Image is not proper")
            case .error:
                XCTAssert(false, "Response is wrong.")
            }
            // Fullfill the expectation
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error: Error?) in
            print("Timeout Error: \(error.debugDescription)")
        }
    }
    
    func testInvalidUrl() {
        let e = expectation(description: "Load Image")
        
        imageView.setImage(withUrl: "sb.png", placeholder: nil) { (completionType) in
            switch completionType {
            case .error(let error):
                XCTAssertEqual(error.localizedDescription, "unsupported URL", "Error message shoud be 'unsupported URL'")
            default:
                XCTAssert(false, "Response is wrong.")
            }
            // Fullfill the expectation
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error: Error?) in
            print("Timeout Error: \(error.debugDescription)")
        }
    }
    
    func testCancelDownload() {
        let e = expectation(description: "Load Image")
        imageView.setImage(withUrl: MDServerImageTestHelper.imageUrl, placeholder: nil) { (completionType) in
            switch completionType {
            case .canceledOrInvalidated:
                XCTAssert(true, "canceledOrInvalidated")
            default:
                XCTAssert(false, "Response is wrong.")
            }
            // Fullfill the expectation
            e.fulfill()
        }

        self.imageView.cancelImageDownload()
        
        waitForExpectations(timeout: 30.0) { (error: Error?) in
            print("Timeout Error: \(error.debugDescription)")
        }
    }
}
