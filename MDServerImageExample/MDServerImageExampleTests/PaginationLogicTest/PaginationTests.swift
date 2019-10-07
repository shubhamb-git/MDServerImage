//
//  PaginationTests.swift
//  MDServerImageExampleTests
//
//  Created by Shubham Bairagi on 06/10/19.
//  Copyright © 2019 sb. All rights reserved.
//

import XCTest
@testable import MDServerImageExample

class PaginationTests: XCTestCase {
    
    private let totalRecords = 12214
    
    func testFirstPage() {
        let page = Page(current: 1, total: totalRecords)
        
        XCTAssertEqual(page.hasNextPage, true, "total records '12214' per page 10. so next page must be exists")
        XCTAssertEqual(page.currentPage, 1, "Current Page should be '1'")
        print(page.totalPage)
        XCTAssertEqual(page.totalPage, 1222, "total Page should be '408', as we have 10 records per page")
//        XCTAssertEqual(page.getNextPage(), 2, "Next page should be '2'")
    }
    
    
}
