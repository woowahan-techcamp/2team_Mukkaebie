//
//  StoreTestViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 15..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

//struct postStruct {
//    var image : UIImage!
//    var name : String!
//}


class StoreTestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rateView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = Bundle.main.loadNibNamed("statusTableViewCell", owner: self, options: nil)?.first as! statusTableViewCell
            return headerView
        }
        
        if section == 1 {
            let logoView = Bundle.main.loadNibNamed("logoTableViewCell", owner: self, options: nil)?.first as! logoTableViewCell
            logoView.logoImage.image = #imageLiteral(resourceName: "woowatech")
            return logoView
            
        }
            
        else if section == 2 {
            let rateView = Bundle.main.loadNibNamed("rateTableViewCell", owner: self, options: nil)?.first as! rateTableViewCell
            return rateView
        }
        else if section == 3 {
            let tapView = Bundle.main.loadNibNamed("segment", owner: self, options: nil)?.first as! segment
            return tapView
        }
        return self.view
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 36
        }
        else if section == 1 {
            return 155
        }
        else if section == 2 {
            return 96
        }
        else if section == 3 {
            return 700
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        else if section == 1 {
            return 0
        }
        else if section == 2 {
            return 0
        }
        else if section == 3 {
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
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
