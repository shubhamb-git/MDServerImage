//
//  MDServerImageOperation.swift
//  MDServerImage
//
//  Created by Shubham on 10/3/19.
//

import Foundation

class MDServerImageOperation: Operation {
    public var invalidated = false
    public var trustsAllCertificates = false
    public var credentials: URLCredential? = nil
    public let identifier: String
    private let finishedCallbackQueue: DispatchQueue
    
    // the request to be made
    private let urlRequest: URLRequest

    private let finishedBlock: ((_ operation: MDServerImageOperation, _ result: DownloadCompletionType) -> ())?

    // the urlsession to use for the request
    private weak var urlSession: URLSession?
    
    private var completionBlockIdentifiers = Set<String>()

    enum State {
        case ready, executing, finished
        func keyPath() -> String {
            switch self {
            case .ready:
                return "isReady"
            case .executing:
                return "isExecuting"
            case .finished:
                return "isFinished"
            }
        }
    }
    
    var state: State = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath())
            willChangeValue(forKey: state.keyPath())
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath())
            didChangeValue(forKey: state.keyPath())
        }
    }
    
    override public func start() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing
            main()
        }
    }
    
    // MARK: - NSOperation
    override public var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override public var isExecuting: Bool {
        return state == .executing
    }
    
    override public var isFinished: Bool {
        return state == .finished
    }
    
    override public var isAsynchronous: Bool {
        return true
    }
    
    init(urlRequest request: URLRequest, identifier id: String, callbackQueue: DispatchQueue, downloadFinishedBlock:  @escaping ((_ operation: MDServerImageOperation, _ result: DownloadCompletionType) -> ())) {
        urlRequest = request
        identifier = id
        finishedBlock = downloadFinishedBlock
        finishedCallbackQueue = callbackQueue
        super.init()
    }
    
    // MARK: - Entry point
    override public func main() {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 10
        configuration.httpShouldUsePipelining = true
        
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        self.urlSession = urlSession
        let task = urlSession.downloadTask(with: urlRequest)
        task.resume()
    }
    
    override func cancel() {
        invalidated = true
        urlSession?.invalidateAndCancel()
        finishedBlock?(self, .canceled)
        super.cancel()
        state = .finished
    }
    
    func matches(urlRequest: URLRequest) -> Bool {
        return urlRequest.url != nil && self.urlRequest.url == urlRequest.url
    }
    
    func appendCompletionBlock(block: (() -> ())?) {
        guard let block = block else { return }
        
        if let completionBlock = completionBlock {
            self.completionBlock = {
                completionBlock()
                block()
            }
        } else {
            completionBlock = block
        }
    }
}

extension MDServerImageOperation: URLSessionTaskDelegate {

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // only connection errors are handled here!
        if let error = error {
            finishedCallbackQueue.async {
                self.finishedBlock?(self, .error(error: error as NSError))
            }
        }
        
        urlSession?.invalidateAndCancel()
        state = .finished
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust, challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if trustsAllCertificates {
                completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
        } else if let credentials = credentials {
            if let currentRequest = task.currentRequest, currentRequest.value(forHTTPHeaderField: "Authorization") == nil {
                completionHandler(.useCredential, credentials)
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
//    URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate
}

extension MDServerImageOperation: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let response = downloadTask.response as? HTTPURLResponse else { return }
        
        if (200...299).contains(response.statusCode) {
            if let data = try? Data(contentsOf: location) {
                if let request = downloadTask.currentRequest {
                    URLCache.shared.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                }
                finishedCallbackQueue.async {
                    self.finishedBlock?(self, .success(data: data))
                }
            } else {
                finishedCallbackQueue.async {
                    self.finishedBlock?(self, .error(error: NSError(domain: "VincentOperation", code: 0, userInfo: [NSLocalizedDescriptionKey: "unable to decode image"])))
                }
            }
        } else {
            finishedCallbackQueue.async {
                self.finishedBlock?(self, .error(error: NSError(domain: "VincentOperation", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "unexepected status code \(response.statusCode)"])))
            }
        }
    }

}
