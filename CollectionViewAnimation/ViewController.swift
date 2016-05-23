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
    var normalLayout = LinfzNormalLayout()
    var largeLayout = LinfzLargeLayout()
    
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
        
        self.collectionViewHeightConstraint.constant = collectionHeight
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
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