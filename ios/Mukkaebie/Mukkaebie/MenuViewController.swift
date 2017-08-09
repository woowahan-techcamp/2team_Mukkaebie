//
//  MenuViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChartView.segments = [
            Segment(color: UIColor(red: 251/255, green: 136/255, blue: 136/255, alpha: 1), value: 57, title: "간지치킨"),
            Segment(color: UIColor(red: 251/255, green: 229/255, blue: 136/255, alpha: 1), value: 30, title: "후라이드"),
            Segment(color: UIColor(red: 232/255, green: 166/255, blue: 93/255, alpha: 1), value: 25, title: "고추치킨"),
            Segment(color: UIColor(white: 179/255, alpha: 1), value: 25, title: "기타")
        ]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
