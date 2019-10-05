//
//  NetworkManager.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

public protocol ServerURL {
    var toUrl: URL? { get }
}
extension URL: ServerURL {
    public var toUrl: URL? { return self }
}
extension String: ServerURL {
    public var toUrl: URL? { return URL(string: self) }
}

protocol NetworkRequest {
    associatedtype ModelType: Decodable
}

extension NetworkRequest {
   
    func load(_ url: ServerURL, withCompletion completion: @escaping (Result<ModelType, NetworkError>) -> Void) {
        guard let url = url.toUrl else {
            completion(.failure(NetworkError.requestError(errorMessage: "Invalid URL.")))
            return
        }
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                completion(.failure(NetworkError.connection(error)))
                return
            } else if let data = data {
                if let model = self.decode(data) {
                    completion(.success(model))
                } else {
                    completion(.failure(NetworkError.corruptedData))
                }
            } else {
                completion(.failure(NetworkError.unknown))
                return
            }
        })
        task.resume()
    }
    
    private func decode(_ data: Data) -> ModelType? {
        let model = try? JSONDecoder().decode(ModelType.self, from: data)
        return model
    }
}
