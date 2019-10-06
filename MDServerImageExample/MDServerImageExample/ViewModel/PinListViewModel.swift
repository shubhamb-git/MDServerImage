//
//  PinListViewModel.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/6/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

enum PinListError {
    case connectionError(Error)
    case mappingFailed
    case reloadFailed
}

struct PinListState {
    
    fileprivate(set) var pins: [PinModel] = []
    fileprivate(set) var page = Page(current: 1, total: 1)
    fileprivate(set) var fetching = false
}

extension PinListState {
    
    enum Change {
        case none
        case fetchStateChanged
        case error(PinListError)
        case pinsChanged(CollectionChange)
    }
    
    mutating func setFetching(fetching: Bool) -> Change {
        self.fetching = fetching
        return .fetchStateChanged
    }
    
    mutating func reload(pins: [PinModel]) -> Change {
        self.pins = pins
        return .pinsChanged(.reload)
    }
    
    mutating func insert(pins: [PinModel]) -> Change {
        let index = self.pins.count
        self.pins.append(contentsOf: pins)
        let range = IndexSet(integersIn: index..<self.pins.count)
        return .pinsChanged(.insertion(range))
    }
    
    mutating func update(page: Page) {
        self.page = page
    }
}

protocol PinListViewModel {
    
    var state: PinListState { get}
    var onChange: ((PinListState.Change) -> Void)? { get set }
    
    func reloadPins()
    func loadMorePins()
}
