//
//  subTableViewCell.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 17..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class subTableViewCell: UITableViewCell {

    @IBOutlet weak var subVC: UIView!

    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        if seg.senderInt == 0 {
//            subVC.addSubview((mukkaebieVC?.view)!)
//        }
//        else if seg.senderInt == 1 {
//            subVC.addSubview((menuRankVC?.view)!)
//        }
        subVC.backgroundColor = .red
    }

}
