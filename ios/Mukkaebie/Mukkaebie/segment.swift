//
//  segment.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

enum tabViewEnum {
    case mukkaebieVC, menuRankVC, infoVC, reviewVC
}


class segment: UITableViewCell {
    
    var modelStore : ModelStores?
    var tabSubview = subTableViewCell()


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
    
    var senderInt = 0
 
    @IBAction func customSegmentValueChanged(_ sender: SegmentView) {
        
        switch  sender.selectedSegmentIndex  {
        case 0:
//            tabSubview.subVC.didAddSubview((mukkaebieVC?.view)!)
//            tabSubview.subVC.
            
            senderInt = 0
        case 1:
//            tabSubview.subVC.didAddSubview((menuRankVC?.view)!)
//            tabSubview.subVC.addSubview((menuRankVC?.view)!)
            senderInt = 1
        case 2:
            senderInt = 2
        case 3:
            senderInt = 3

        default:
            break
        }
        print("11111111111111",senderInt)
        print("0",sender.selectedSegmentIndex)

        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dump(modelStore)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSubViewHeight() {
        
    }
    
    
}
