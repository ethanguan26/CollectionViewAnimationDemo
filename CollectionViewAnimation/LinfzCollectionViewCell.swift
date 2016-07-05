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
        NotificationCenter.default().addObserver(self, selector: #selector(LinfzCollectionViewCell.didTapCollectionView(_:)), name: DidTapCollectionViewNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LinfzCollectionViewCell.tapGesture(_:)))
        titleLabel.addGestureRecognizer(tapGesture)
        titleLabel.isUserInteractionEnabled = true
        
    }
    
    func tapGesture(_ gesture:UITapGestureRecognizer) {
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
        
        NotificationCenter.default().post(name: Notification.Name(rawValue: DidTapCollectionViewNotification), object: self, userInfo: viewInfo as [NSObject : AnyObject])
    }

    
    func didTapCollectionView(_ notification:Notification) {
        //do something just like layout cell's subviews
    }

}
