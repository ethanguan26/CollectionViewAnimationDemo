//
//  LinfzNormalLayout.swift
//  CollectionViewAnimation
//
//  Created by YGuan on 16/5/23.
//  Copyright © 2016年 YGuan. All rights reserved.
//

import UIKit

class LinfzNormalLayout: UICollectionViewFlowLayout {
    
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
        
        itemSize = CGSizeMake(ITEM_NORMAL_WIDTH, ITEM_NORMAL_HEIGHT);
        scrollDirection = .Horizontal
        minimumLineSpacing = ITEM_SPACING
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        
        let numberOfItems = collectionView!.numberOfItemsInSection(0)
        
        for index in 0 ..< numberOfItems{
            let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.frame.origin.y = newBounds.size.height - (cell?.frame.size.height)!
            cell?.contentView.frame.origin.y = (cell?.frame.origin.y)!
        }
        return false
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        
        var targetPoint = CGPointZero
        if targetIndex == 1 {
            targetPoint.x = itemSize.width * 1.5 + ITEM_SPACING - ScreenWidth / 2
        } else if targetIndex > 1  && targetIndex < (collectionView?.numberOfItemsInSection(0))! - 1{
            targetPoint.x = itemSize.width * 1.5 + ITEM_SPACING - ScreenWidth / 2 + CGFloat(targetIndex - 1) * (itemSize.width + ITEM_SPACING)
        } else if targetIndex ==  (collectionView?.numberOfItemsInSection(0))! - 1 {
            targetPoint.x =  itemSize.width * 3 + ITEM_SPACING * 2 - ScreenWidth + CGFloat(targetIndex - 1) * (itemSize.width + ITEM_SPACING)
        }
        
        return CGPoint(x: targetPoint.x, y: proposedContentOffset.y)
    }

}
