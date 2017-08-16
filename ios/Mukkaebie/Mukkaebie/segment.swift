//
//  segment.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class segment: UITableViewCell {

    @IBOutlet weak var tabSubView: UIView!
    
    @IBOutlet weak var tabSubHeight: NSLayoutConstraint!
    
    var currentVC : UIViewController?
    lazy var mukkaebieVC : UIViewController? = {
        let storyboard = UIStoryboard(name: "MukkaebieRank", bundle: nil)
        let mukkaebieVC = storyboard.instantiateViewController(withIdentifier: "MukkaebieRank") as? MukkaebieRankViewController
        return mukkaebieVC
    }()
    
    lazy var menuRankVC : UIViewController? = {
        let storyboard = UIStoryboard(name: "MenuView", bundle: nil)
        let menuRankVC = storyboard.instantiateViewController(withIdentifier: "Menu") as? MenuViewController
        return menuRankVC
    }()
 
    @IBAction func customSegmentValueChanged(_ sender: SegmentView) {
//        var vc : UIViewController?
        switch  sender.selectedSegmentIndex  {
        case 0:
            tabSubView.addSubview((mukkaebieVC?.view)!)
            tabSubHeight.constant = (mukkaebieVC?.view.frame.height)!

        case 1:
            tabSubView.addSubview((menuRankVC?.view)!)
            tabSubHeight.constant = (mukkaebieVC?.view.frame.height)!

        default:
            break
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
