//
//  ViewController.swift
//  PieChart
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 hyeongjong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pieChartView.segments = [
            Segment(color: UIColor(red: 82/255, green: 72/255, blue: 156/255, alpha: 1), value: 57, title: "양념치킨"),
            Segment(color: UIColor(red: 78/255, green: 205/255, blue: 196/255, alpha: 1), value: 30, title: "후라이드치킨"),
            Segment(color: UIColor(red: 1, green: 107/255, blue: 107/255, alpha: 1), value: 25, title: "간장치킨"),
            Segment(color: UIColor(white: 224/255, alpha: 1), value: 25, title: "기타")
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

