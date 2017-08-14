//
//  circleView.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 14..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

//@IBDesignable

class circleView : UIView {
    
//    @IBInspectable var cornerRadius : CGFloat = 0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = cornerRadius > 0
//        }
//    }
//    
//    @IBInspectable var borderWidth : CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.init(hexString: "00c09f").cgColor
        self.layer.masksToBounds = true
    }
    
    
    
}

