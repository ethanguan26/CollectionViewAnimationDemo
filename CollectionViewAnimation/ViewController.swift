//
//  ViewController.swift
//  CollectionViewAnimation
//
//  Created by YGuan on 5/20/16.
//  Copyright © 2016 YGuan. All rights reserved.
//

import UIKit

let DidTapCollectionViewNotification = "DidTapCollectionView"

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    var itemType = ItemType.Small
    var originType = ItemType.Small
    var selectedIndex = 0
    var isTurnToBigSize = false
    
    //MARK: - life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.registerNib(UINib(nibName: "LinfzCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didTapCollectionView(_:)), name: DidTapCollectionViewNotification, object: nil)
    }
}

// MARK: - method
extension ViewController {
    func didTapCollectionView(notification:NSNotification) {
        if let userInfo = notification.userInfo {
            itemType = ItemType(rawValue: (userInfo["currentItemType"]?.integerValue)!)!
            selectedIndex = (notification.userInfo?["tapedCellIndex"]?.integerValue)!
            originType = ItemType(rawValue: (notification.userInfo?["originItemType"]?.integerValue)!)!
            isTurnToBigSize = (notification.userInfo?["isTurnToBigSize"]?.boolValue)!
        }else {
            itemType = .Small
            originType = .Large
            isTurnToBigSize = false
        }
        layoutCollectionViewSubviews()
    }
    
    func layoutCollectionViewSubviews() {
        var itemSize = CGSize()
        var locationHeight:CGFloat
        var heightConstraint: CGFloat
        
        let sizeAndHeight = getItemSizeAndContainer(itemType)
        itemSize = sizeAndHeight.itemSize
        locationHeight = sizeAndHeight.locationHeight
        
        switch itemType {
        case .Small:
            heightConstraint = 128
        case .Normal:
            heightConstraint = 0
        case .Large:
            heightConstraint = 0
        }
        
//        if isTurnToBigSize {
//            startAnimationTurnToBigSize(itemSize, top: mapDescriptionTop, hide: currentPlaceButtonHide,locationHeight: locationHeight)
//        }else {
//            startAnimationTurnToSmallSize(itemSize, top: mapDescriptionTop, hide: currentPlaceButtonHide, locationHeight: locationHeight)
//        }

    }
    
    func getCurrentItemWidth(itemType:ItemType) -> CGFloat {
        var itemWidth:CGFloat = 0.0;
        if itemType == .Small {
            itemWidth = ITEM_SMALL_WIDTH
        }else if itemType == .Normal {
            itemWidth = ITEM_NORMAL_WIDTH
        }else {
            itemWidth = ScreenWidth
        }
        return itemWidth
    }
    
    func getItemSizeAndContainer(itemType:ItemType) -> (itemSize:CGSize,locationHeight:CGFloat) {
        var itemSize = CGSizeZero
        var locationHeight = CGFloat()
        
        switch itemType {
        case .Small:
            itemSize = CGSizeMake(ITEM_SMALL_WIDTH, ITEM_SMALL_HEIGHT)
            locationHeight = ITEM_SMALL_HEIGHT
            
        case .Normal:
            itemSize = CGSizeMake(ITEM_NORMAL_WIDTH, ITEM_NORMAL_HEIGHT)
            locationHeight = ITEM_NORMAL_HEIGHT
            
        case .Large:
            itemSize = CGSizeMake(ScreenWidth, ScreenHeight - 64)
            locationHeight = ScreenHeight - 64
        }
        return (itemSize,locationHeight)
        
    }


}

// MARK: - collectinView dataSource and collectionView delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! LinfzCollectionViewCell
        
        cell.titleLabel.text = "\(indexPath.row + 1)"
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1)
        cell.currentItemType = itemType
        cell.originItemType = originType
        cell.index = indexPath.row
        return cell
    }
}