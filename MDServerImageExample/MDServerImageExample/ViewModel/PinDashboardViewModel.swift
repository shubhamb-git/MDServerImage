//
//  PinDashboardViewModel.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

class PinDashboardViewModel: NetworkRequest, PinListViewModel {
    
    typealias ModelType = [PinModel]
    
    fileprivate(set) var state = PinListState()

    var onChange: ((PinListState.Change) -> Void)?
    
    func reloadPins() {
        state.update(page: Page.default)
        
        fetchPin(page: 0) { [weak self] (pins) in
            guard let strongSelf = self else { return }
            strongSelf.onChange?(strongSelf.state.reload(pins: pins))
            
        }
    }
    
    func loadMorePins() {
        guard state.page.hasNextPage, !state.fetching else { return }
        
        fetchPin(page: state.page.getNextPage()) { [weak self] (pins) in
            guard let strongSelf = self else { return }
            strongSelf.onChange?(strongSelf.state.insert(pins: pins))
        }
    }
}

extension PinDashboardViewModel {
    
    func fetchPin(page: Int, handler: @escaping ([PinModel]) -> Void) {
        Helper.dispatchAsyncMain { [unowned self] in
            self.onChange?(self.state.setFetching(fetching: true))
        }
        load(AppConstants.pastebinUrl) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.state.update(page: Page(current: page, total: 50))
                handler(response)
            case .failure(let error):
                strongSelf.onChange?(.error(.connectionError(error)))
            }
            strongSelf.onChange?(strongSelf.state.setFetching(fetching: false))
        }
    }
}
