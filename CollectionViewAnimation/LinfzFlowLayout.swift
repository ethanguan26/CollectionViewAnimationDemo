//
//  LinfzFlowLayout.swift
//  CollectionViewAnimation
//
//  Created by YGuan on 5/20/16.
//  Copyright © 2016 YGuan. All rights reserved.
//

import UIKit

enum ItemType : Int{
    case Small = 0
    case Normal = 1
    case Large = 2
}

let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height
let ITEM_NORMAL_HEIGHT = ScreenHeight - 90 - 64
let ITEM_SMALL_HEIGHT = CGFloat(200)
let ITEM_NORMAL_WIDTH = CGFloat(ScreenWidth - 40)
let ITEM_SMALL_WIDTH = CGFloat(130) + (ScreenWidth - 320) / 2
let ITEM_SPACING = CGFloat(6)

class LinfzFlowLayout: UICollectionViewFlowLayout {
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
    
    

}
