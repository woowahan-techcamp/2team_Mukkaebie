//
//  CartPaymentViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 20..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class CartPaymentViewController: UIViewController {

    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderCountLabel: UILabel!
    
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    var modelStore : ModelStores?
    let networkOrder = NetworkOrder()
    var orderList = [ModelOrders]()
    var priceByMenu = [String: Int]()
    var orderByMenu = [String: Int]()
    var orderByMenuSorted = [(key: String, value: Int)]()
    
    var menuName = String()
    var menuPrice = String()
    
    var totalPrice = 0
    var orderCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        menuPriceLabel.text = menuPrice
        menuNameLabel.text = menuName
        totalPrice = Int(menuPrice.substring(to: menuPrice.index(before: menuPrice.endIndex)).replacingOccurrences(of: ",", with: ""))!
        totalPriceLabel.text = "\(totalPrice)원"
        
        minusButton.layer.borderColor = UIColor.init(hexString: "cfcfcf").cgColor
        minusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = UIColor.init(hexString: "cfcfcf").cgColor
        plusButton.layer.borderWidth = 1
        orderCountLabel.layer.borderColor = UIColor.init(hexString: "cfcfcf").cgColor
        orderCountLabel.layer.borderWidth = 1
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func touchedPlusButton(_ sender: Any) {
        orderCount += 1
        orderCountLabel.text = String(orderCount)
        totalPriceLabel.text = "\(totalPrice * orderCount)원"
        
    }
    
    @IBAction func touchedMinusButton(_ sender: Any) {
        if orderCount > 0 {
            orderCount -= 1
            orderCountLabel.text = String(orderCount)
            totalPriceLabel.text = "\(totalPrice * orderCount)원"

        }
        
    }
    
    
    @IBAction func touchedOrder(_ sender: Any) {
        if priceByMenu.count > 0 {
            networkOrder.postOrder(sellderId: (modelStore?.id)!, buyerId: "hjtech", price: totalPrice, content: [menuName])
        }
        
        
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
