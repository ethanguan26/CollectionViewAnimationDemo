//
//  LinfzLargeLayout.swift
//  CollectionViewAnimation
//
//  Created by YGuan on 16/5/23.
//  Copyright © 2016年 YGuan. All rights reserved.
//

import UIKit

class LinfzLargeLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    func config(){
        
        itemSize = CGSizeMake(ScreenWidth, ScreenHeight);
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
}
