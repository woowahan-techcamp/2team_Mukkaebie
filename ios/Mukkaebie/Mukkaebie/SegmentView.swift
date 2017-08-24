//
//  circleView.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 14..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

@IBDesignable

class SegmentView : UIControl {
    
    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0
 
    @IBInspectable
    var borderWidth : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor : UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var separatedButtonTitle : String = "" {
        didSet {
            updateView()
        }
    }
   
    @IBInspectable
    var textColor: UIColor = .black {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorColor: UIColor = .darkGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorTextColor: UIColor = .blue {
        didSet {
            updateView()
        }
    }
    
    
    func updateView() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        let buttonTitles = separatedButtonTitle.components(separatedBy: ",")
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = borderWidth
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        selector = UIView(frame: CGRect(x: 0, y: 34, width: selectorWidth, height: 6))
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        
    }
    
    func buttonTapped(button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            
            if btn == button {
                selectedSegmentIndex = buttonIndex
                let selectorStart = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0, animations: {
                    self.selector.frame.origin.x = selectorStart
                })
                
                
                btn.setTitleColor(selectorTextColor, for: .normal)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTab"), object: nil, userInfo: ["tabNumber":buttonIndex])
            }
            
        }
        
        sendActions(for: .valueChanged)
    }
    
    
    /*
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height/2
    }
 */

}

