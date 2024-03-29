//
//  PinterestLayout.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

protocol PinterestCollectionViewLayoutDelegate: class {
    func numberOfItemsInSection(section: Int) -> Int
    
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
    
    func collectionView(_ collectionView:UICollectionView, heightForFooterAtIndexPath indexPath:IndexPath) -> CGFloat?
}

class PinterestCollectionViewLayout: UICollectionViewLayout {

    weak var delegate: PinterestCollectionViewLayoutDelegate!
    
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 6
    
    var cache = [UICollectionViewLayoutAttributes]()
    var footerLayoutAttributes: UICollectionViewLayoutAttributes?
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    func clearCacheAndPrepare() {
        cache.removeAll()
        prepare()
    }
    
    override func prepare() {

        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        let items = delegate.numberOfItemsInSection(section: 0)
        
        for item in 0 ..< items {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height

            column = column < (numberOfColumns - 1) ? (column + 1) : 0

            if item == items - 1 {
                let footerIndexPath = IndexPath(item: 0, section: 0)
                if let footerHeight = delegate.collectionView(collectionView, heightForFooterAtIndexPath: footerIndexPath) {
                    let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: footerIndexPath)
                   
                    let footerFrame = CGRect(x: 0, y: yOffset[column], width: collectionView.bounds.width , height: footerHeight)
                   
                    footerAttributes.frame = footerFrame
                    footerLayoutAttributes = footerAttributes
                    cache.append(footerLayoutAttributes!)
                    
                    contentHeight = max(contentHeight, footerFrame.maxY)
                }
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return footerLayoutAttributes
    }
}

