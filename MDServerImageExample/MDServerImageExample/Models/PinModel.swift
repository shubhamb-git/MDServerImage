//
//  PinModel.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

struct PinModel: Decodable {
    let id: String?
    let createdAt: String?
    let width: Double?
    let height: Double?
    let color: String?
    let likes: Int?
    let likedByUser: Bool?
    let user: UserModel?
    let currentUserCollections: [String]?
    let urls: UrlModel?
    let categories: [CategoryModel]?
    let links: PinLinkModel?
}
