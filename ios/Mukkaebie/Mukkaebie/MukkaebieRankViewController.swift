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
        
        firstBottomConstraint.constant -= view.bounds.height
        secondBottomConstraint.constant -= view.bounds.height
        thirdBottomConstraint.constant -= view.bounds.height

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
            self.firstBottomConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 2, delay: 0.5, options: .curveEaseInOut, animations: {
            self.secondBottomConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.thirdBottomConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func firstProfileImagePicker(_ sender: Any) {
        
        
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
