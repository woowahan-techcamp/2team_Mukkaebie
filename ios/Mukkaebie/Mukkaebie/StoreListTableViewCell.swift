//
//  StoreListTableViewCell.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class StoreListTableViewCell: UITableViewCell {

    @IBOutlet weak var storeLogoImage: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var reviewNumaberLabel: UILabel!
    @IBOutlet weak var directPaymentLabel: UILabel!
    @IBOutlet weak var meetPaymentLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        storeLogoImage.layer.cornerRadius = storeLogoImage.frame.height / 2
        storeLogoImage.layer.borderColor = UIColor(hexString: "eeeeee").cgColor
        storeLogoImage.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
