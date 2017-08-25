//
//  segment.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

enum tabViewEnum {
    case mukkaebieVC, menuRankVC, infoVC, reviewVC
}


class segment: UITableViewCell {
    
    @IBOutlet weak var segmentView: SegmentView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
