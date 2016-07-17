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
    var selectedIndex = 0
    var isTurnToBigSize = false
    
    var smallLayout = LinfzFlowLayout()
    var normalLayout = LinfzFlowLayout()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        smallLayout.itemSize = LinfzSize.SmallItemSize
        normalLayout.itemSize = LinfzSize.NormalItemSize
        collectionView.registerNib(UINib(nibName: "LinfzCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.decelerationRate = 0.3
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didTapCollectionView(_:)), name: DidTapCollectionViewNotification, object: nil)
        collectionViewHeightConstraint.constant = LinfzSize.SmallItemSize.height
        collectionView.setCollectionViewLayout(smallLayout, animated: false)
    }
}

// MARK: - Method
extension ViewController {
    func didTapCollectionView(notification:NSNotification) {
        if let userInfo = notification.userInfo {
            itemType = ItemType(rawValue: (userInfo["currentItemType"]?.integerValue)!)!
            selectedIndex = (notification.userInfo?["tapedCellIndex"]?.integerValue)!
            isTurnToBigSize = (notification.userInfo?["isTurnToBigSize"]?.boolValue)!
        }else {
            itemType = .Small
            isTurnToBigSize = false
        }
        layoutCollectionViewSubviews()
    }
    
    func layoutCollectionViewSubviews() {
        var collectionHeight:CGFloat
        var headerHeight: CGFloat
        var layout: UICollectionViewFlowLayout?
        let sizeAndHeight = LinfzHelper.getItemSizeAndContainer(itemType)
        collectionHeight = sizeAndHeight.locationHeight
        
        switch itemType {
        case .Small:
            headerHeight = 90
            layout = smallLayout
        case .Normal:
            headerHeight = 0
            layout = normalLayout
        }
        
        layout?.setValue(selectedIndex, forKey: "targetIndex")
        self.collectionViewHeightConstraint.constant = collectionHeight
        
        // 替换collectionview的layout，从而改变大小，这部分代码可自行调整看看效果，目前这样实现感觉效果比较平滑可以接受。
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
    
}

// MARK: - CollectinView dataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! LinfzCollectionViewCell
        cell.titleLabel.text = "\((indexPath as NSIndexPath).row + 1)"
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1)
        
        //设置cell的类型
        cell.currentItemType = itemType
        
        //由于项目中使用的cell情况有些特殊，所以没有使用didSelect的代理方法，需要对cell设置一个索引。
        cell.index = (indexPath as NSIndexPath).row
        return cell
    }
    
}



//MARK: - ScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    
    
    /**
     控制scrollView滑动动画结束时scrollView滑动的位置
     
     - parameter scrollView:          滑动的scrollview
     - parameter velocity:            用户松手时滑动的速率(CGPoint标示)
     - parameter targetContentOffset: 动画结束时的停止位置
     */
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // 计算出滑动目的地位置
        
        if velocity == CGPoint.zero {
            return
        } else if velocity.x > 0 {
            selectedIndex += 1
        } else if velocity.x < 0 {
            selectedIndex -= 1
        }
        
        // 作为第一个cell与最后元素的处理
        if selectedIndex < 0 {
            selectedIndex = 0
        } else if selectedIndex > collectionView.numberOfItemsInSection(0) - 1 {
            selectedIndex = collectionView.numberOfItemsInSection(0) - 1
        }

        let sizeAndHeight = LinfzHelper.getItemSizeAndContainer(itemType)
        let itemSize = sizeAndHeight.itemSize
        let targetPoint = LinfzHelper.targetPoint(selectedIndex, itemSize: itemSize, itemCounts: (collectionView?.numberOfItemsInSection(0))!)
        targetContentOffset.memory = CGPoint(x: CGFloat(targetPoint.x),y: CGFloat(targetPoint.y))
        scrollView.setContentOffset(targetPoint, animated: true)
    }
    
}

