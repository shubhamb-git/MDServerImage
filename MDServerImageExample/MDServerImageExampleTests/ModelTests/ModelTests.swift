//
//  ModelTests.swift
//  MDServerImageExampleTests
//
//  Created by Shubham Bairagi on 06/10/19.
//  Copyright © 2019 sb. All rights reserved.
//

import XCTest
@testable import MDServerImageExample

class ModelTests: XCTestCase {

    enum FileType {
        case pins
    }
    
    func JSONFrom(fileType: FileType) -> Data? {
        let fileName: String
        switch fileType {
        case .pins:
            fileName = "Pins"
        }
        
        let pathURL = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json")
        guard let url = pathURL else {
            XCTFail("There is no such a file '\(fileName)")
            return nil
        }
        
        guard let data = try? Data.init(contentsOf: url) else {
            XCTFail("Cannot convert json file to data")
            return nil
        }
        return data
    }
 
    func testPinModel() {
        guard let data = JSONFrom(fileType: .pins) else {
                XCTFail("Movie didn't mapped. Missing parameters (non optinals)")
                return
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let pins = try? jsonDecoder.decode([PinModel].self, from: data)

        XCTAssertEqual(10, pins?.count, "Pins count is wrong. Should be '10'")
        
        if let pin = pins?.first {
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
    }
    
}
