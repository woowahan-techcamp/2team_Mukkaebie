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
        
    @IBAction func customSegmentValueChanged(_ sender: SegmentView) {
        
        switch  sender.selectedSegmentIndex  {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTab"), object: nil, userInfo: ["tabNumber":0])
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTab"), object: nil, userInfo: ["tabNumber":1])
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTab"), object: nil, userInfo: ["tabNumber":2])
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTab"), object: nil, userInfo: ["tabNumber":3])

        default:
            break
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
