//
//  NetworkError.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case unknown
    case connection(Error)
    case corruptedData
    case requestError(errorMessage: String)
}

extension NetworkError: LocalizedError {
   
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown Error"
        case .corruptedData:
            return "Response data is not in correct format"
        case .requestError(let message):
            return message
        default:
            return localizedDescription
        }
    }
}
