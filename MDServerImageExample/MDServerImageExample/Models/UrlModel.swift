//
//  UrlModel.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

struct UrlModel: Decodable {
	let raw: String?
	let full: String?
	let regular: String?
	let small: String?
	let thumb: String?
}
