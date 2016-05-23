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
    case Large = 2
}

let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height
let ITEM_NORMAL_HEIGHT = ScreenHeight - 90
let ITEM_SMALL_HEIGHT = CGFloat(200)
let ITEM_NORMAL_WIDTH = CGFloat(ScreenWidth - 40)
let ITEM_SMALL_WIDTH = CGFloat(130) + (ScreenWidth - 320) / 2
let ITEM_SPACING = CGFloat(6)
