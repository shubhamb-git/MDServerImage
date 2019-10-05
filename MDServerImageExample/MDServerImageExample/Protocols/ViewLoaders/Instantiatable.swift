//
//  Instantiatable.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

protocol Instantiatable {
    static func instantiate() -> Self
}

extension Instantiatable where Self: NibLoadable {
    static func instantiate() -> Self {
        return loadFromNib()
    }
}

extension Instantiatable where Self: StoryboardLoadable {
    static func instantiate() -> Self {
        return loadFromStoryboard()
    }
}
