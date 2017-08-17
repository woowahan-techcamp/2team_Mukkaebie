//
//  segment.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class segment: UITableViewCell {
    
    var modelStore : ModelStores?

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
    
    lazy var infoVC : UIViewController? = {
        let storyboard = UIStoryboard(name: "Info", bundle: nil)
        let infoVC = storyboard.instantiateViewController(withIdentifier: "Info") as? InfoViewController
        infoVC?.introText = self.modelStore?.storeDesc
        infoVC?.openHourText = self.modelStore?.openHour
        infoVC?.telephoneText = self.modelStore?.telephone
        infoVC?.nameText = self.modelStore?.name
        return infoVC
    }()
    
    lazy var reviewVC : UITableViewController? = {
        let storyboard = UIStoryboard(name: "Review", bundle: nil)
        let reviewVC = storyboard.instantiateViewController(withIdentifier: "Review") as? ReviewTableViewController
        return reviewVC
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
        
        case 2:
            tabSubView.addSubview((infoVC?.view)!)
            tabSubHeight.constant = (infoVC?.view.frame.height)!
        
        case 3:
            tabSubView.addSubview((reviewVC?.tableView)!)
            tabSubHeight.constant = (reviewVC?.tableView.frame.height)!
            
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
