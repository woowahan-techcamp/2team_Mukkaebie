//
//  StoreListMenuBarCollectionViewCell.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class StoreListMenuBarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var foodCategoryLabel: UILabel!
    
    override func prepareForReuse() {
        
    }
    
    override func layoutSubviews() {
        
        foodCategoryLabel.textColor = UIColor.white
        foodCategoryLabel.textAlignment = .center
        foodCategoryLabel.invalidateIntrinsicContentSize()
        foodCategoryLabel.layoutIfNeeded()
    }
}

