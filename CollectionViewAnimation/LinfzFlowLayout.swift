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
    
    /**
     改变cell的layout之前做的事，UICollectionViewFlowLayout还有其他的代理方法，可以将一下代码位置换到其他代理方法中看看效果。
     
     - parameter newBounds: 改变后的cell的bounds
     
     - returns:返回YES是需要重新布局cell，返回NO，则不重新布局。由于实际项目中cell有一些布局改动，所以这里没有把重新布局交给系统
     */
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
    /**
     设置变化大小之后collectionview停留的位置
     
     - parameter proposedContentOffset: 系统自己的目标位置
     
     - returns: 返回需要更改的目标位置
     */
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        let targetPoint = LinfzHelper.targetPoint(targetIndex, itemSize: itemSize, itemCounts: (collectionView?.numberOfItemsInSection(0))!)
        return CGPoint(x: targetPoint.x, y: proposedContentOffset.y)
    }
}
