//
//  LinkModel.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

class Links: Decodable {
    let `self`: String?
    let html: String?
}

class PinLinkModel: Links {
    let download: String? = nil
}

class CategoryLinkModel: Links {
    let photos: String? = nil
}

class UserProfileLinkModel: CategoryLinkModel {
    let likes: String? = nil
}
