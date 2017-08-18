//
//  TabSubviewTableViewCell.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 17..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class TabSubviewTableViewCell: UITableViewCell {

    @IBOutlet weak var tabSubview: UIView!
    @IBOutlet weak var tabSubviewHeightConstraint: NSLayoutConstraint!
    
    var didSetupConstraints = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.autoresizesSubviews = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
