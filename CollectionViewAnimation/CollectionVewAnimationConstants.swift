//
//  CollectionVewAnimationConstants.swift
//  CollectionViewAnimation
//
//  Created by YGuan on 16/5/23.
//  Copyright © 2016年 YGuan. All rights reserved.
//

import Foundation
import UIKit

enum ItemType : Int{
    case Small = 0
    case Normal = 1
}

struct LinfzSize {
    static let ScreenWidth = UIScreen.main().bounds.size.width
    static let ScreenHeight = UIScreen.main().bounds.size.height
    static let SmallItemSize = CGSize(width: CGFloat(lroundf(130.0 * Float(ScreenWidth) / 320.0)) , height: CGFloat(lroundf(200.0 * Float(ScreenWidth) / 320.0)))
    static let NormalItemSize = CGSize(width: ScreenWidth, height: ScreenHeight)
    static let Spacing:CGFloat = 2.0
}

class LinfzHelper {
    class func targetPoint(_ selectedIndex: Int,itemSize: CGSize, itemCounts: Int) -> CGPoint {
        var targetPoint = CGPoint.zero
        if selectedIndex == 1 {
            targetPoint.x = itemSize.width * 1.5 + LinfzSize.Spacing - LinfzSize.ScreenWidth / 2
        } else if selectedIndex > 1  && selectedIndex < itemCounts - 1{
            targetPoint.x = itemSize.width * 1.5 + LinfzSize.Spacing - LinfzSize.ScreenWidth / 2 + CGFloat(selectedIndex - 1) * (itemSize.width + LinfzSize.Spacing)
        } else if selectedIndex ==  itemCounts - 1 {
            targetPoint.x =  itemSize.width * 3 + LinfzSize.Spacing * 2 - LinfzSize.ScreenWidth + CGFloat(selectedIndex - 2) * (itemSize.width + LinfzSize.Spacing)
        }
        return targetPoint
    }
    
    
    class func getItemSizeAndContainer(_ itemType:ItemType) -> (itemSize:CGSize,locationHeight:CGFloat) {
        var itemSize = CGSize.zero
        var locationHeight = CGFloat()
        switch itemType {
        case .Small:
            itemSize = LinfzSize.SmallItemSize
            locationHeight = itemSize.height
        case .Normal:
            itemSize = LinfzSize.NormalItemSize
            locationHeight = itemSize.height
        }
        return (itemSize,locationHeight)
        
    }
    
}
