//
//  MD5StringTest.swift
//  MDServerImageExampleTests
//
//  Created by Shubham on 10/7/19.
//  Copyright © 2019 sb. All rights reserved.
//

import XCTest
@testable import MDServerImage

class MD5StringTest: XCTestCase {

    func testMD5StringDigest() {
        let testString = "Shubham"
        XCTAssertEqual(testString.md5digest(), "7894debad19a114b7d584359c33af99c", "MD5 digest is wrong. Should be '7894debad19a114b7d584359c33af99c'")
    }

}
