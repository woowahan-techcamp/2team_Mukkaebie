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
    // the color of a given segment
    var color: UIColor
    
    // the value of a given segment – will be used to automatically calculate a ratio
    var value: CGFloat
    
    // the title of given segment
    var title: String
}

class PieChartView: UIView {
        
    /// An array of structs representing the segments of the pie chart
    var segments = [Segment]() {
        didSet {
            setNeedsDisplay() // re-draw view when the values get set
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false // when overriding drawRect, you must specify this to maintain transparency.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        // height for title
        let titleHeight: CGFloat = 20
        
        let padding: CGFloat = 10
        
        // get current context
        let ctx = UIGraphicsGetCurrentContext()
        
        // radius is the half the frame's width or height (whichever is smallest)
        let radius = min(frame.size.width, frame.size.height) * 0.5 - titleHeight - padding
        
        // center of the view
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        
        // enumerate the total value of the segments by using reduce to sum them
        let valueCount = segments.reduce(0, {$0 + $1.value})
        
        // the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).
        var startAngle = -CGFloat.pi * 0.5
        
        var compX: CGFloat = 0
        
        let titleView = UIView(frame: CGRect(x: 0, y: frame.size.height-20, width: frame.size.width, height: 20))
        self.addSubview(titleView)
        
        for segment in segments { // loop through the values array
            
            // set fill color to the segment color
            ctx?.setFillColor(segment.color.cgColor)
            
            // update the end angle of the segment
            let endAngle = startAngle + 2 * .pi * (segment.value / valueCount)
            
            // move to the center of the pie chart
            //ctx?.move(to: viewCenter)
            ctx?.addArc(center: viewCenter, radius: 4/5*radius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
            // add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            // fill segment
            ctx?.fillPath()
            
            // update starting angle of the next segment to the ending angle of this segment
            startAngle = endAngle
            
            let colorRect = CGRect(x: compX, y: 7.5, width: 5, height: 5)
            let rectView = UIView(frame: colorRect)
            rectView.backgroundColor = segment.color
            titleView.addSubview(rectView)
            
            compX += 10
            
            let label = UILabel(frame: CGRect(x: compX, y: 0, width: 200, height: 20))
            label.font = label.font.withSize(titleHeight-5)
            label.textColor = .black
            label.text = segment.title
            label.frame.size = label.intrinsicContentSize
            titleView.addSubview(label)
            
            compX += label.frame.size.width+10
        }
        
        titleView.sizeToFitCustom()
        titleView.center.x = self.frame.size.width / 2
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
