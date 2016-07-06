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
        collectionView.register(UINib(nibName: "LinfzCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.decelerationRate = 0.3
        NotificationCenter.default().addObserver(self, selector: #selector(ViewController.didTapCollectionView(_:)), name: DidTapCollectionViewNotification, object: nil)
        collectionViewHeightConstraint.constant = LinfzSize.SmallItemSize.height
        collectionView.setCollectionViewLayout(smallLayout, animated: false)
    }
}

// MARK: - Method
extension ViewController {
    func didTapCollectionView(_ notification:Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            itemType = ItemType(rawValue: (userInfo["currentItemType"]?.intValue)!)!
            selectedIndex = ((notification as NSNotification).userInfo?["tapedCellIndex"]?.intValue)!
            isTurnToBigSize = ((notification as NSNotification).userInfo?["isTurnToBigSize"]?.boolValue)!
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
        
        if isTurnToBigSize {
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            if !self.isTurnToBigSize {
                self.view.layoutIfNeeded()
            }
            self.collectionView.setCollectionViewLayout(layout!, animated: true)
        }) { (finish) in
            UIView.animate(withDuration: 0.3, animations: {
                self.headerHeightConstraint.constant = headerHeight
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
}

// MARK: - CollectinView dataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LinfzCollectionViewCell
        
        cell.titleLabel.text = "\((indexPath as NSIndexPath).row + 1)"
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1)
        cell.currentItemType = itemType
        cell.index = (indexPath as NSIndexPath).row
        return cell
    }
}

//MARK: - ScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity == CGPoint.zero {
            return
        } else if velocity.x > 0 {
            selectedIndex += 1
        } else if velocity.x < 0 {
            selectedIndex -= 1
        }
        
        if selectedIndex < 0 {
            selectedIndex = 0
        } else if selectedIndex > collectionView.numberOfItems(inSection: 0) - 1 {
            selectedIndex = collectionView.numberOfItems(inSection: 0) - 1
        }

        let sizeAndHeight = LinfzHelper.getItemSizeAndContainer(itemType)
        let itemSize = sizeAndHeight.itemSize
        let targetPoint = LinfzHelper.targetPoint(selectedIndex, itemSize: itemSize, itemCounts: (collectionView?.numberOfItems(inSection: 0))!)
        targetContentOffset.pointee = CGPoint(x: CGFloat(targetPoint.x),y: CGFloat(targetPoint.y))
        scrollView.setContentOffset(targetPoint, animated: true)
    }
    
}

