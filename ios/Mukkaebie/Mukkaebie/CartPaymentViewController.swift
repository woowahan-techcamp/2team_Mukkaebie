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
    
    var modelStoreId = Int()
    var modelStore = ModelStores()
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
        
        navigationController?.setNavigationBarHidden(false, animated: false)
//        self.navigationItem.title = modelStore?.name
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        
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

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let image = #imageLiteral(resourceName: "750x1334_merge_alpha.png")
        alertController.addimage(image: image)
        alertController.view.tintColor = UIColor.black
        alertController.viewWillLayoutSubviews()
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
            self.networkOrder.postOrder(sellderId: self.modelStore.id, buyerId: "hjtech", price: self.totalPrice, content: [self.menuName])

        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func touchedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
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