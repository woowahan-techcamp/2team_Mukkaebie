//
//  LaunchScreen.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 28..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class LaunchScreen: UIView {
    @IBOutlet weak var bannerImage: UIImageView!

    @IBOutlet weak var mukkaebieImage: UIImageView!
    
     @IBOutlet weak var rainyImage: UIImageView!
    
    @IBOutlet weak var companyStackView: UIStackView!
    
    
    static func startLaunch(target: MainViewController) {
        var launchView = UINib(nibName: "LaunchView", bundle: nil).instantiate(withOwner: target, options: nil)[0] as! UIView
        launchView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+(target.tabBarController?.tabBar.frame.height)!)
        target.tabBarController?.tabBar.isHidden = true
        target.view.addSubview(launchView)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) { 
            launchView.removeFromSuperview()
            target.tabBarController?.tabBar.isHidden = false
        }
    }
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
     
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
    */

}
