//
//  StoreTestViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 15..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController {
    
    lazy var mukkaebieVC : MukkaebieRankViewController? = {
        let storyboard = UIStoryboard(name: "MukkaebieRank", bundle: nil)
        let mukkaebieVC = storyboard.instantiateViewController(withIdentifier: "MukkaebieRank") as? MukkaebieRankViewController
        
        return mukkaebieVC
    }()
    
    lazy var menuRankVC : MenuViewController? = {
        let storyboard = UIStoryboard(name: "MenuView", bundle: nil)
        let menuRankVC = storyboard.instantiateViewController(withIdentifier: "Menu") as? MenuViewController
        
        return menuRankVC
    }()
    
    lazy var infoVC : InfoViewController? = {
        let storyboard = UIStoryboard(name: "Info", bundle: nil)
        let infoVC = storyboard.instantiateViewController(withIdentifier: "Info") as? InfoViewController

        return infoVC
    }()
    
    lazy var reviewVC : ReviewTableViewController? = {
        let storyboard = UIStoryboard(name: "Review", bundle: nil)
        let reviewVC = storyboard.instantiateViewController(withIdentifier: "Review") as? ReviewTableViewController
        
        return reviewVC
    }()
    
    var storeId = Int()
    var modelStore : ModelStores?
    let networkStore = NetworkStore()
    
    let networkOrder = NetworkOrder()
    var orderList = [ModelOrders]()
    var orderByUser = [String:Int]()
    var orderByUserTop3 = [(key: String, value: Int)]()
    var orderByMenuSorted = [(key: String, value: Int)]()
    

    let indicatorView = Indicator()

    var tabNumber = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var cartAlertView: UIView!
    @IBOutlet var noMukkaebieView: UIView!
    @IBOutlet var noMenuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        cartAlertView.center = self.view.center
        cartAlertView.layer.masksToBounds = true
        cartAlertView.layer.cornerRadius = 1
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(getOrderList(_:)), name: NSNotification.Name(rawValue: "getOrder"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postOrder(_:)), name: NSNotification.Name(rawValue: "postOrder"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeTab(_:)), name: NSNotification.Name(rawValue: "changeTab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(touchedSubTableView(_:)), name: NSNotification.Name(rawValue: "touchedSubTableView"), object: nil)
        
        NetworkStore.getStoreList(sellerId: self.storeId) {(storeList) in
            Store.sharedInstance.specificStore = storeList[0]
            
            self.navigationItem.title = Store.sharedInstance.specificStore?.name
            self.menuRankVC?.initItem()
            self.menuRankVC?.initMenus()
            
            self.networkOrder.getOrderList(sellerId: self.storeId)
            self.tableView.reloadData()
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        indicatorView.showProgressView(view: self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getOrderList(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let orderInfo = userInfo["orderList"] as? [ModelOrders] else { return }
        self.orderList = orderInfo
        
        getOrderByMenu()
        getOrderByUser()
        let indexPath = IndexPath(row: 0, section: 3)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func getOrderByMenu() {
        Store.sharedInstance.specificStore.initOrderByMenu()
        
        for order in self.orderList {
            for content in order.content {
                Store.sharedInstance.specificStore.orderByMenu[content]! += 1
            }
        }
        
        orderByMenuSorted = Store.sharedInstance.specificStore.orderByMenu.sorted(by: { $0.1 > $1.1 })
        
        if orderByMenuSorted.count > 3 {
            var count = 0
            for i in (3 ..< orderByMenuSorted.count).reversed() {
                count += orderByMenuSorted[i].value
                orderByMenuSorted.removeLast()
            }
            orderByMenuSorted.append((key: "기타", value: count))
        }
        
        menuRankVC?.orderByMenuSorted = self.orderByMenuSorted
        
        if orderList.count == 0 {
            menuRankVC?.noOrder = true
        } else {
            menuRankVC?.noOrder = false
        }
        if (menuRankVC?.pieChartView != nil) {
            menuRankVC?.setSegment()
        }
    }
    
    func getOrderByUser() {
        for order in self.orderList {
            if orderByUser[order.buyerId] == nil {
                orderByUser[order.buyerId] = 1
            } else {
                orderByUser[order.buyerId]! += 1
            }
        }
        
        let orderByUserSorted = orderByUser.sorted(by: { $0.1 > $1.1 })
        
        for i in orderByUserSorted.count > 3 ? 0..<3 : 0..<orderByUserSorted.count {
            self.orderByUserTop3.append(orderByUserSorted[i])
        }
    
        mukkaebieVC?.orderByUserTop3 = self.orderByUserTop3
    }
    
    func postOrder(_ notification: Notification) {
        self.networkOrder.getOrderList(sellerId: storeId)
    }
    
    func changeTab(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let tabNumber = userInfo["tabNumber"] as? Int else { return }
        
        self.tabNumber = tabNumber
        
        let indexPath = IndexPath(row: 0, section: 3)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func touchedSubTableView(_ notification: Notification) {
        let indexPath = IndexPath(row: 0, section: 3)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @IBAction func touchedShoppingCart(_ sender: Any) {

        self.view.addSubview(cartAlertView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) { 
            self.cartAlertView.removeFromSuperview()
        }
    }
    
    @IBAction func touchedOrderCall(_ sender: Any) {
        let url = NSURL(string: "tel://\((Store.sharedInstance.specificStore?.telephone)!)")
        UIApplication.shared.openURL(url as! URL)
    }
}



extension StoreDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = Bundle.main.loadNibNamed("statusTableViewCell", owner: self, options: nil)?.first as! statusTableViewCell
            return headerView
        }
        
        if section == 1 {
            let logoView = Bundle.main.loadNibNamed("logoTableViewCell", owner: self, options: nil)?.first as! logoTableViewCell
            if let url = URL(string: (Store.sharedInstance.specificStore?.imgURL)!) {
                logoView.logoImage.af_setImage(withURL: url)
            } else {
                logoView.logoImage.image  = #imageLiteral(resourceName:"woowatech")
            }
            return logoView
        }
            
        if section == 2 {
            let rateView = Bundle.main.loadNibNamed("rateTableViewCell", owner: self, options: nil)?.first as! rateTableViewCell
            rateView.ratingValue.text = String(describing: floor((Store.sharedInstance.specificStore?.ratingValue)!*10)/10)
            return rateView
        }
        
        if section == 3 {
            let tapView = Bundle.main.loadNibNamed("segment", owner: self, options: nil)?.first as! segment
            
            tapView.segmentView.frame.size.width = self.view.frame.width
            tapView.segmentView.updateView()
            
            return tapView.contentView
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
            return 40
        }
        return 0

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if Store.sharedInstance.specificStore == nil {
            return 0
        }
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
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TabSubviewTableViewCell
        
        for subview in cell.tabSubview.subviews {
            subview.removeFromSuperview()
        }
        
        switch tabNumber {
        case 0:
            if orderByUserTop3.count == 0 {
                cell.tabSubview.frame.size.height = noMukkaebieView.frame.height
                cell.tabSubviewHeightConstraint.constant = noMukkaebieView.frame.height
                cell.tabSubview.addSubview(noMukkaebieView)
            } else {
                cell.tabSubview.frame.size.height = (mukkaebieVC?.view.frame.height)!
                cell.tabSubviewHeightConstraint.constant = (mukkaebieVC?.view.frame.height)!
                cell.tabSubview.addSubview((mukkaebieVC?.view)!)
            }
        case 1:
            if Store.sharedInstance.specificStore?.menu.count == 0 {
                cell.tabSubview.frame.size.height = noMenuView.frame.height
                cell.tabSubviewHeightConstraint.constant = noMenuView.frame.height
                cell.tabSubview.addSubview(noMenuView)
            } else {
                cell.tabSubview.frame.size.height = (menuRankVC?.view.frame.height)!
                cell.tabSubviewHeightConstraint.constant = (menuRankVC?.view.frame.height)!
                cell.tabSubview.addSubview((menuRankVC?.view)!)
            }
        case 2:
            cell.tabSubview.frame.size.height = (infoVC?.view.frame.height)!
            cell.tabSubviewHeightConstraint.constant = (infoVC?.view.frame.height)!
            cell.tabSubview.addSubview((infoVC?.view)!)
        case 3:
            cell.tabSubview.frame.size.height = (reviewVC?.tableView.contentSize.height)!
            cell.tabSubviewHeightConstraint.constant = (reviewVC?.tableView.contentSize.height)!
            cell.tabSubview.addSubview((reviewVC?.view)!)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Store.sharedInstance.specificStore == nil {
            return 0
        }
        switch tabNumber {
        case 0:
            if orderByUserTop3.count == 0 {
                return noMukkaebieView.frame.height
            }
            return (mukkaebieVC?.view.frame.height)!
        case 1:
            if Store.sharedInstance.specificStore?.menu.count == 0 {
                return noMenuView.frame.height
            }
            return (menuRankVC?.view.frame.height)!
        case 2:
            return (infoVC?.view.frame.height)!
        case 3:
            return (reviewVC?.tableView.contentSize.height)!
        default:
            break
        }
        return 0
    }
}
