//
//  LinfzFlowLayout.swift
//  CollectionViewAnimation
//
//  Created by YGuan on 5/20/16.
//  Copyright © 2016 YGuan. All rights reserved.
//

import UIKit

class LinfzFlowLayout: UICollectionViewFlowLayout {
    
    var targetIndex = 0
    
    override init() {
        super.init()
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    func config(){
        itemSize = LinfzSize.SmallItemSize
        scrollDirection = .horizontal
        minimumLineSpacing = LinfzSize.Spacing
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let cells = collectionView?.visibleCells()
        if let visibleCells = cells {
            for visibleCell in visibleCells {
                if visibleCell.frame.size.height < newBounds.size.height {
                    visibleCell.frame.origin.y = newBounds.size.height - visibleCell.frame.size.height
                }
            }
        }
        return false
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let targetPoint = LinfzHelper.targetPoint(targetIndex, itemSize: itemSize, itemCounts: (collectionView?.numberOfItems(inSection: 0))!)
        return CGPoint(x: targetPoint.x, y: proposedContentOffset.y)
    }
    
    override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        print("prepareForAnimatedBoundsChange")
        super.prepare(forAnimatedBoundsChange: oldBounds)
    }
    
    override func prepareForTransition(to newLayout: UICollectionViewLayout) {
        print("prepareForTransitionToLayout")
        super.prepareForTransition(to: newLayout)
    }
    
    override func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        print("prepareForTransitionFromLayout")
        super.prepareForTransition(from: oldLayout)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("layoutAttributesForItemAtIndexPath \(indexPath)")
        return super.layoutAttributesForItem(at: indexPath)
    }

}
