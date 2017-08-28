//
//  InfoViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 17..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var openHourLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        introLabel.text = Store.sharedInstance.specificStore?.storeDesc
        openHourLabel.text = Store.sharedInstance.specificStore?.openHour
        telephoneLabel.text = Store.sharedInstance.specificStore?.telephone
        nameLabel.text = Store.sharedInstance.specificStore?.name

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
