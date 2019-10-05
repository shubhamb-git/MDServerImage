//
//  PinDashboardViewModel.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

protocol PinResponseDelegate: class {
    func didReceivedResponse()
    func didfailed(with error: String?)
}

class PinDashboardViewModel: NetworkRequest {
    typealias ModelType = [PinModel]
    
    var pins: [PinModel]?
    
    weak var pinResponseDelegate: PinResponseDelegate?
    
    init(with delegate: PinResponseDelegate) {
        self.pinResponseDelegate = delegate
    }
    
    func fetchPin() {
        
        load(AppConstants.pastebinUrl) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.pins = response
                strongSelf.pinResponseDelegate?.didReceivedResponse()
            case .failure(let error):
                strongSelf.pins = nil
                strongSelf.pinResponseDelegate?.didfailed(with: error.errorDescription)
            }
        }
    }
}
