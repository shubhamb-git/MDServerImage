//
//  Constant.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

struct AppConstants {

    static let pastebinUrl: String = "http://pastebin.com/raw/wgkJgazE"

    struct PlaceHolder {
        struct Image {
            static let userImage = UIImage(named: "userIcon")
        }
        struct Text {
            static let noRecordFound = "NO USER FOUND"
            static let pullToRefresh = "Pull To Refresh"
            static let connectionError = "Connection Error"
            static let connectionErrorMessage = "Check your network status and pull to refresh"
            static let invalidData = "Invalid Data"
            static let invalidDataErrorMessage = "There is an error when getting data from server. Please pull to refresh"
        }
    }
}
