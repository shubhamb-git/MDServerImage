//
//  NSObjectExtension.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

extension NSObject {
    
    // Name Of class
    class var stringRepresentation: String {
        let name = String(describing: self)
        return name
    }
}
