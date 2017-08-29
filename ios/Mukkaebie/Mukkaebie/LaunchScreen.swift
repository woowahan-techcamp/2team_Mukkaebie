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
    
    @IBOutlet weak var mukkaebieImageBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bannerImageCenterConstraint: NSLayoutConstraint!
    
    func initLaunch(target: MainViewController) {
        self.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+(target.tabBarController?.tabBar.frame.height)!)
        
        bannerImageCenterConstraint.constant -= bannerImage.frame.width

        mukkaebieImageBottomConstraint.constant -= mukkaebieImage.frame.height
        
        self.layoutIfNeeded()
    }
    
    func startLaunch(target: MainViewController) {
        target.tabBarController?.tabBar.isHidden = true
        target.view.addSubview(self)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
            self.removeFromSuperview()
            target.tabBarController?.tabBar.isHidden = false
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
            //
            self.bannerImageCenterConstraint.constant += self.bannerImage.frame.width
            self.layoutSubviews()
        }, completion: nil)
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
            self.mukkaebieImageBottomConstraint.constant += self.mukkaebieImage.frame.height
            self.layoutSubviews()
        }, completion: nil)
    }
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
     
     super.viewDidLoad()
     
     
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
