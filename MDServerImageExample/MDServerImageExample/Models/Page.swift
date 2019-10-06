//
//  Page.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/6/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

struct Page {
    
    static let `default` = Page(current: 1, total: 1)
    static let itemPerPage = 10
    
    let currentPage: Int
    let totalPage: Int
    
    var hasNextPage: Bool {
        return currentPage < totalPage
    }
    
    init(current: Int, total: Int) {
        totalPage = total
        currentPage = current > 0 ? current : 1
    }
    
    func getNextPage() -> Int {
        return currentPage + 1
    }
    
}

