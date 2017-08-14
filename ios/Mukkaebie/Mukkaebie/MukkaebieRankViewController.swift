//
//  MukkaebieRankViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class MukkaebieRankViewController: UIViewController {
    @IBOutlet weak var mukkaebieMessage: UILabel!
    @IBOutlet weak var mukkaebieCommentTextField: UITextField!

    @IBOutlet weak var firstMukkaebieImage: UIImageView!
    @IBOutlet weak var secondMukkaebieImage: UIImageView!
    @IBOutlet weak var thirdMukkaebieImage: UIImageView!
    
    @IBOutlet weak var firstAward: UIView!
    @IBOutlet weak var secondAward: UIView!
    @IBOutlet weak var thirdAward: UIView!
    
    @IBOutlet weak var firstBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstMukkaebieImage.layer.cornerRadius = firstMukkaebieImage.frame.height/2
        secondMukkaebieImage.layer.cornerRadius = secondMukkaebieImage.frame.height/2
        thirdMukkaebieImage.layer.cornerRadius = thirdMukkaebieImage.frame.height/2
        firstMukkaebieImage.layer.borderWidth = 4
        firstMukkaebieImage.layer.borderColor = UIColor(hexString: "2AC1BC").cgColor
        secondMukkaebieImage.layer.borderWidth = 4
        secondMukkaebieImage.layer.borderColor = UIColor(hexString: "2AC1BC").cgColor
        thirdMukkaebieImage.layer.borderWidth = 4
        thirdMukkaebieImage.layer.borderColor = UIColor(hexString: "2AC1BC").cgColor

        
        firstBottomConstraint.constant -= view.bounds.height
        secondBottomConstraint.constant -= view.bounds.height
        thirdBottomConstraint.constant -= view.bounds.height

        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
            self.firstBottomConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 2, delay: 0.3, options: .curveEaseInOut, animations: {
            self.secondBottomConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        var bounds = thirdAward.bounds
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - 20, width: bounds.size.width, height: bounds.size.height + 60)
            self.view.layoutIfNeeded()
        },completion: nil)
        
        
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
