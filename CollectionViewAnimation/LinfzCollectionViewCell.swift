//
//  LinfzCollectionViewCell.swift
//  CollectionViewAnimation
//
//  Created by YGuan on 5/20/16.
//  Copyright © 2016 YGuan. All rights reserved.
//

import UIKit

class LinfzCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var index = 0
    var isTurnToBigSize = true
    var currentItemType:ItemType = .Small
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LinfzCollectionViewCell.didTapCollectionView(_:)), name: DidTapCollectionViewNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LinfzCollectionViewCell.tapGesture(_:)))
        titleLabel.addGestureRecognizer(tapGesture)
        titleLabel.userInteractionEnabled = true
        
    }
    
    func tapGesture(gesture:UITapGestureRecognizer) {
        let type = currentItemType
        switch type {
        case .Small:
            currentItemType = .Normal
            isTurnToBigSize = true
        case .Normal:
            currentItemType = .Small
            isTurnToBigSize = false
        }
        sendInfo()
    }
    
    func sendInfo() {
        
        let viewInfo = ["tapedCellIndex":index,
                        "currentItemType":"\(currentItemType.rawValue)",
                        "isTurnToBigSize":"\(isTurnToBigSize)"]

        NSNotificationCenter.defaultCenter().postNotificationName(DidTapCollectionViewNotification, object: self, userInfo: viewInfo as [NSObject : AnyObject])
    }

    
    func didTapCollectionView(notification:NSNotification) {
        //do something just like layout cell's subviews
    }

}
