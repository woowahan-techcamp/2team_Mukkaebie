//
//  LaunchViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 27..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var mukkaebieImage: UIImageView!
    @IBOutlet weak var rainImage: UIImageView!
    
    @IBOutlet weak var bannerCenter: NSLayoutConstraint!
    @IBOutlet weak var mukkaebieBotton: NSLayoutConstraint!

    @IBOutlet weak var rainBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerCenter.constant += bannerImage.frame.width
        mukkaebieBotton.constant -= mukkaebieImage.frame.height
        self.rainBottom.constant -= rainImage.frame.height
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2) {
            self.rainBottom.constant += self.rainImage.frame.height
            self.bannerCenter.constant -= self.bannerImage.frame.width
            self.mukkaebieBotton.constant += self.mukkaebieImage.frame.height
            self.view.layoutSubviews()
        }
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
