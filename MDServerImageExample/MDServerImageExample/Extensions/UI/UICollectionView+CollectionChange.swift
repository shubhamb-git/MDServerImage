//
//  UICollectionView+CollectionChange.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/6/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func applyCollectionChange(_ change: CollectionChange, toSection section: Int) {
        func makeIndexPath(using index: Int) -> IndexPath {
            return IndexPath(row: index, section: section)
        }
        
        func makeIndexPaths(using indexSet: IndexSet) -> [IndexPath] {
            return indexSet.map { makeIndexPath(using: $0) }
        }
        
        switch change {
        case .update(let indexes):
            reloadItems(at: makeIndexPaths(using: indexes.toIndexSet()))
        case .insertion(let indexes):
            insertItems(at: makeIndexPaths(using: indexes.toIndexSet()))
        case .deletion(let indexes):
            deleteItems(at: makeIndexPaths(using: indexes.toIndexSet()))
        case .move(let from, let to):
            moveItem(at: makeIndexPath(using: from), to: makeIndexPath(using: to))
        case .reload:
            reloadData()
        }
    }
}
