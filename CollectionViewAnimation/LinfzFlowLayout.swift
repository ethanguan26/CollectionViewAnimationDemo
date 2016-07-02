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
        scrollDirection = .Horizontal
        minimumLineSpacing = LinfzSize.Spacing
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
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
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        let targetPoint = LinfzHelper.targetPoint(targetIndex, itemSize: itemSize, itemCounts: (collectionView?.numberOfItemsInSection(0))!)
        return CGPoint(x: targetPoint.x, y: proposedContentOffset.y)
    }

}
