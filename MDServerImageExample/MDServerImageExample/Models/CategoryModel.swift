//
//  CategoryModel.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

struct CategoryModel: Decodable {
	let id: Int?
	let title: String?
	let photoCount: Int?
	let links: CategoryLinkModel?
}
