//
//  MenuTableViewCell.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //UITapGestureRecognizer(target: self, action: #selector(tapHeader))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
