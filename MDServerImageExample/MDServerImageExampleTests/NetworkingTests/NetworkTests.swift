//
//  NetworkTests.swift
//  MDServerImageExampleTests
//
//  Created by Shubham Bairagi on 06/10/19.
//  Copyright © 2019 sb. All rights reserved.
//

import XCTest
@testable import MDServerImageExample

class NetworkTests: XCTestCase, NetworkRequest {
    
    typealias ModelType = [PinModel]
    
    func testPins() {
        let e = expectation(description: "Pin list")
        
        load(AppConstants.pastebinUrl) { (result) in
            switch result {
            case .success(let response):
                if let pin = response.first {
                    XCTAssert((type(of: pin) == PinModel.self), "Not a pin type")
                    
                    XCTAssertEqual("4kQA1aQK8-Y", pin.id, "Pin id is wrong. Should be '4kQA1aQK8-Y'")
                    
                    if let user = pin.user {
                        XCTAssert((type(of: user) == UserModel.self), "Not a user type")
                        XCTAssertEqual("OevW4fja2No", user.id, "Pin id is wrong. Should be 'OevW4fja2No'")
                    } else {
                        XCTAssert(false, "User Response is wrong.")
                    }
                } else {
                    XCTAssert(false, "Response is wrong.")
                }
            case .failure(let error):
                XCTAssertNil(error, "An error occured: \(error)")
            }
            // Fullfill the expectation
            e.fulfill()
        }
        waitForExpectations(timeout: 30.0) { (error: Error?) in
            print("Timeout Error: \(error.debugDescription)")
        }
    }
}
