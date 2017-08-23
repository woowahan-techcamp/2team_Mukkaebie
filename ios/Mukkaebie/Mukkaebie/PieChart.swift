//
//  PieChart.swift
//  PieChart
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 hyeongjong. All rights reserved.
//

import Foundation
import UIKit

struct Segment {
    var color: UIColor
    var value: CGFloat
    var title: String
    var price: String
}

class PieChartView: UIView {
    
    var segments = [Segment]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        //padding for view
        let padding: CGFloat = 25
        
        // height for title
        let titleHeight: CGFloat = 15
        
        //array for titleView
        var titleViews : [UIView] = []
        
        //add first titleView
        titleViews.append(UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 15)))
        
        //x position of composition
        var compX: CGFloat = 0
        
        //count for titleViews
        var titleViewsCount = 0
        
        //function for adding titleViews
        func addTitle(segment: Segment, newLine: Bool, overWidth: Bool) {
            
            //add new line
            if newLine {
                titleViews.append(UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 20)))
                
                compX = 0
                titleViewsCount += 1
            }
            
            //make color rectangle
            let colorRect = CGRect(x: compX, y: 5 + titleHeight * CGFloat(titleViewsCount), width: 10, height: 10)
            
            //setting the view for rectangle
            let rectView = UIView(frame: colorRect)
            rectView.backgroundColor = segment.color
            titleViews[titleViewsCount].addSubview(rectView)
            
            //update compX
            compX += 9 + 6
            
            let button : UIButton
            
            //if text is over the width of frame, then width of button is width of frame
            if !overWidth {
                button = UIButton(frame: CGRect(x: compX, y: titleHeight * CGFloat(titleViewsCount), width: 200, height: 20))
            } else {
                button = UIButton(frame: CGRect(x: compX, y: titleHeight * CGFloat(titleViewsCount), width: frame.size.width - padding - 15, height: 20))
            }
            
            //setting the button
            let buttonAttributes : [String: Any] = [
                NSFontAttributeName : UIFont.init(name: "BMHANNA11yrsoldOTF", size: 16),
                NSForegroundColorAttributeName : UIColor.init(hexString: "333333"),
                NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
            
            if segment.title.contains("기타") == true {
                button.isEnabled = false
            } else {
                button.isEnabled = true
            }
            
            button.isUserInteractionEnabled = true
            button.isHighlighted = true
            button.setTitleColor(UIColor.init(hexString: "999999"), for: .highlighted)
            
            let attributeString = NSMutableAttributedString(string: segment.title, attributes: buttonAttributes)
            button.setAttributedTitle(attributeString, for: .normal)
            button.setTitleColor(UIColor(hexString: "333333"), for: .normal)

            
            //if text is not over the width of frame, then manipulate the size of button to fit the size of it's content
            if !overWidth {
                button.titleLabel?.frame.size = button.titleLabel!.intrinsicContentSize
                button.frame.size.width = button.titleLabel!.frame.size.width
            }
            
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            titleViews[titleViewsCount].addSubview(button)
            
            //update compX
            compX += button.frame.size.width+20
        }
        
        for segment in segments {
            let width = segment.title.size(attributes: [NSFontAttributeName: UIFont(name: "BMHANNA11yrsoldOTF", size: 15)!]).width
            
            if 15 + width > frame.size.width - padding {
                if titleViews[titleViewsCount].subviews.count == 0 {
                    addTitle(segment: segment, newLine: false, overWidth: true)
                } else {
                    addTitle(segment: segment, newLine: true, overWidth: true)
                }
            } else if compX + 15 + width > frame.size.width - padding {
                addTitle(segment: segment, newLine: true, overWidth: false)
            } else {
                addTitle(segment: segment, newLine: false, overWidth: false)
            }
        }
        
        for titleView in titleViews {
            titleView.frame = CGRect(x: 0, y: frame.size.height - titleHeight * CGFloat(titleViewsCount) - padding, width: frame.size.width, height: 20)
            titleViewsCount -= 1
        
            self.addSubview(titleView)
            titleView.sizeToFitCustom()
            titleView.center.x = self.frame.size.width / 2
        }
        
        // get current context
        let ctx = UIGraphicsGetCurrentContext()
        
        // radius is the half the frame's width or height (whichever is smallest)
        let radius = (min(frame.size.width, frame.size.height) - titleHeight * CGFloat(titleViews.count) - padding ) * 0.5
        
        // center of the view
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: (bounds.size.height - titleHeight * CGFloat(titleViews.count) - padding) * 0.5)
        
        // enumerate the total value of the segments by using reduce to sum them
        let valueCount = segments.reduce(0, {$0 + $1.value})
        
        var startAngle = -CGFloat.pi * 0.5
        
        for segment in segments { // loop through the values array
            
            // set fill color to the segment color
            ctx?.setFillColor(segment.color.cgColor)
            
            // update the end angle of the segment
            let endAngle = startAngle + 2 * .pi * (segment.value / valueCount)
            
            // move to the center of the pie chart
            //ctx?.move(to: viewCenter)
            ctx?.addArc(center: viewCenter, radius: 0.45 * radius, startAngle: endAngle, endAngle: startAngle, clockwise: true)

            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            // fill segment
            ctx?.fillPath()
            
            // update starting angle of the next segment to the ending angle of this segment
            startAngle = endAngle
        }
    }
    
    func titleClick(title : String)  {
        
        let cartStoryboard = UIStoryboard(name: "CartPayment", bundle: nil)
        let cartViewController = cartStoryboard.instantiateViewController(withIdentifier: "Cart") as! CartPaymentViewController
        let currentController = self.getCurrentViewController()
        var titleArray = title.components(separatedBy: " ")
        titleArray.removeLast()
        let titleString = titleArray.reduce(" ") { $0 + $1 }
        var menuPriceString = String()
        for segment in segments {
            if title == segment.title {
            menuPriceString = segment.price
            }
        }
        cartViewController.menuPrice = menuPriceString
        cartViewController.menuName = titleString
        currentController?.present(cartViewController, animated: false, completion: nil)
        
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
    
    func buttonAction(sender: UIButton!) {
        titleClick(title: (sender.titleLabel?.text)!)
    }
}

extension UIView {
    final func sizeToFitCustom() {
        var w: CGFloat = 0,
        h: CGFloat = 0
        for view in subviews {
            if view.frame.origin.x + view.frame.width > w { w = view.frame.origin.x + view.frame.width }
            if view.frame.origin.y + view.frame.height > h { h = view.frame.origin.y + view.frame.height }
        }
        frame.size = CGSize(width: w, height: h)
    }
}
