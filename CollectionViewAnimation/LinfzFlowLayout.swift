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
        itemSize = CGSizeMake(ITEM_SMALL_WIDTH, ITEM_SMALL_HEIGHT);
        scrollDirection = .Horizontal
        minimumLineSpacing = ITEM_SPACING
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        #if false
        let numberOfItems = collectionView!.numberOfItemsInSection(0)
        for index in 0 ..< numberOfItems{
            let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.frame.origin.y = newBounds.size.height - (cell?.frame.size.height)!
        }
            #endif
        
        #if true
            
            let cells = collectionView?.visibleCells()
            if let visibleCells = cells {
                for visibleCell in visibleCells {
                    if visibleCell.frame.size.height < newBounds.size.height {
                        visibleCell.frame.origin.y = newBounds.size.height - visibleCell.frame.size.height
                    }
                }
            }


            #endif
        
        return false
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        var targetPoint = CGPointZero
        if targetIndex == 1 {
            targetPoint.x = itemSize.width * 1.5 + ITEM_SPACING - ScreenWidth / 2
        } else if targetIndex > 1  && targetIndex < (collectionView?.numberOfItemsInSection(0))! - 1{
            targetPoint.x = itemSize.width * 1.5 + ITEM_SPACING - ScreenWidth / 2 + CGFloat(targetIndex - 1) * (itemSize.width + ITEM_SPACING)
        } else if targetIndex ==  (collectionView?.numberOfItemsInSection(0))! - 1 {
            targetPoint.x =  itemSize.width * 3 + ITEM_SPACING * 2 - ScreenWidth + CGFloat(targetIndex - 2) * (itemSize.width + ITEM_SPACING)
        }
        print("after change collection-view layout then move to ===> \(targetPoint.x)")
        return CGPoint(x: targetPoint.x, y: proposedContentOffset.y)
    }

}
