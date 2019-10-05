//
//  UserModel.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

struct UserModel: Decodable {
	let id: String?
	let username: String?
	let name: String?
	let profileImage: ProfileImageModel?
	let links: UserProfileLinkModel?
}
