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
        
        foodCategoryLabel.textColor = UIColor(red: 111/255, green: 105/255, blue: 99/255, alpha: 1)
        foodCategoryLabel.backgroundColor = UIColor(hexString: "3B342C")
    }
}

