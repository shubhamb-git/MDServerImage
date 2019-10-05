//
//  Helpers.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

class Helper {
    
    class func dispatchAsyncMain(_ block: @escaping () -> Void)  {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }    
}
