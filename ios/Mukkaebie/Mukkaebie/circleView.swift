//
//  circleView.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 14..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

@IBDesignable

class CircleView : UIView {
 
    @IBInspectable
    var borderWidth : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var backColor: UIColor = UIColor.clear {
        didSet {
            layer.backgroundColor = backColor.cgColor
        }
    }
    
    
    @IBInspectable
    var borderColor : UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.width / 2.0
        
        self.layer.cornerRadius = radius
    }

}

