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
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var itemType = ItemType.Small
    var originType = ItemType.Small
    var selectedIndex = 0
    var isTurnToBigSize = false
    
    var smallLayout = LinfzFlowLayout()
    var normalLayout = LinfzFlowLayout()
    var largeLayout = LinfzFlowLayout()
    
    //MARK: - life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        smallLayout.itemSize = CGSize(width: ITEM_SMALL_WIDTH, height: ITEM_SMALL_HEIGHT)
        normalLayout.itemSize = CGSize(width: ITEM_NORMAL_WIDTH, height: ITEM_NORMAL_HEIGHT)
        largeLayout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight)
        
        collectionView.registerNib(UINib(nibName: "LinfzCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.decelerationRate = 0.3
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didTapCollectionView(_:)), name: DidTapCollectionViewNotification, object: nil)
        
    }
}

// MARK: - Method
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
        var collectionHeight:CGFloat
        var headerHeight: CGFloat
        var layout: UICollectionViewFlowLayout?
        let sizeAndHeight = getItemSizeAndContainer(itemType)
        collectionHeight = sizeAndHeight.locationHeight
        
        switch itemType {
        case .Small:
            headerHeight = 90
            layout = smallLayout
        case .Normal:
            headerHeight = 0
            layout = normalLayout
        case .Large:
            headerHeight = 0
            layout = largeLayout
        }
        
        layout?.setValue(selectedIndex, forKey: "targetIndex")
        self.collectionViewHeightConstraint.constant = collectionHeight
        
        if isTurnToBigSize {
            self.view.layoutIfNeeded()
        }
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
            if !self.isTurnToBigSize {
                self.view.layoutIfNeeded()
            }
            self.collectionView.setCollectionViewLayout(layout!, animated: true)
        }) { (finish) in
            UIView.animateWithDuration(0.3, animations: {
                self.headerHeightConstraint.constant = headerHeight
                self.view.layoutIfNeeded()
            })
        }
        
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
            itemSize = CGSizeMake(ScreenWidth, ScreenHeight)
            locationHeight = ScreenHeight
        }
        return (itemSize,locationHeight)
        
    }
}

// MARK: - CollectinView dataSource
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

//MARK: - ScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity == CGPointZero {
            return
        }
        
        if velocity.x > 0 {
            selectedIndex += 1
        }
        if velocity.x < 0{
            selectedIndex -= 1
        }
        if selectedIndex < 0 {
            selectedIndex = 0
        } else if selectedIndex > collectionView.numberOfItemsInSection(0) - 1 {
            selectedIndex = collectionView.numberOfItemsInSection(0) - 1
        }

        let sizeAndHeight = getItemSizeAndContainer(itemType)
        let itemSize = sizeAndHeight.itemSize
        
        var targetPoint = CGPointZero
        if selectedIndex == 1 {
            targetPoint.x = itemSize.width * 1.5 + ITEM_SPACING - ScreenWidth / 2
        } else if selectedIndex > 1  && selectedIndex < (collectionView?.numberOfItemsInSection(0))! - 1{
            targetPoint.x = itemSize.width * 1.5 + ITEM_SPACING - ScreenWidth / 2 + CGFloat(selectedIndex - 1) * (itemSize.width + ITEM_SPACING)
        } else if selectedIndex ==  (collectionView?.numberOfItemsInSection(0))! - 1 {
            targetPoint.x =  itemSize.width * 3 + ITEM_SPACING * 2 - ScreenWidth + CGFloat(selectedIndex - 2) * (itemSize.width + ITEM_SPACING)
        }
        
        targetContentOffset.memory = CGPoint(x: CGFloat(targetPoint.x),y: CGFloat(targetPoint.y))
        scrollView.setContentOffset(targetPoint, animated: true)
    }
    
}

