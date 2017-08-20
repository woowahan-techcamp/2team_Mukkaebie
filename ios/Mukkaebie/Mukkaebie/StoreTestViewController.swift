//
//  StoreTestViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 15..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class StoreTestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var mukkaebieVC : MukkaebieRankViewController? = {
        let storyboard = UIStoryboard(name: "MukkaebieRank", bundle: nil)
        let mukkaebieVC = storyboard.instantiateViewController(withIdentifier: "MukkaebieRank") as? MukkaebieRankViewController
        mukkaebieVC?.view.frame.size.height = 540
        return mukkaebieVC
    }()
    
    lazy var menuRankVC : MenuViewController? = {
        let storyboard = UIStoryboard(name: "MenuView", bundle: nil)
        let menuRankVC = storyboard.instantiateViewController(withIdentifier: "Menu") as? MenuViewController
        if (self.modelStore?.menu.count)! > 0 {
        let menu = (self.modelStore?.menu)![0]
            for (title, submenu) in menu {
                let item = MenuViewModelItem(sectionTitle: title, rowCount: submenu.count, isCollapsed: false)
                menuRankVC?.items.append(item)
                var menu : [(key: String, value: String)] = []
                for (name, price) in submenu {
                    menu.append((key: name, value: price))
                }
                menuRankVC?.menus.append(menu)
            }
        }
        
        menuRankVC?.orderByMenuSorted = self.orderByMenuSorted
        return menuRankVC
    }()
    
    lazy var infoVC : InfoViewController? = {
        let storyboard = UIStoryboard(name: "Info", bundle: nil)
        let infoVC = storyboard.instantiateViewController(withIdentifier: "Info") as? InfoViewController
        infoVC?.introText = self.modelStore?.storeDesc
        infoVC?.openHourText = self.modelStore?.openHour
        infoVC?.telephoneText = self.modelStore?.telephone
        infoVC?.nameText = self.modelStore?.name
        infoVC?.view.frame.size.height = 667
        return infoVC
    }()
    
    lazy var reviewVC : ReviewTableViewController? = {
        let storyboard = UIStoryboard(name: "Review", bundle: nil)
        let reviewVC = storyboard.instantiateViewController(withIdentifier: "Review") as? ReviewTableViewController
        return reviewVC
    }()
    
    var modelStore : ModelStores?
    let networkOrder = NetworkOrder()
    var orderList = [ModelOrders]()
    var priceByMenu = [String:Int]()
    var orderByMenu = [String:Int]()
    var orderByMenuSorted = [(key: String, value: Int)]()
    
    var tabNumber = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = modelStore?.name
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let menu = (self.modelStore?.menu)![0]
        for (title, submenu) in menu {
            for (name, price) in submenu {
                orderByMenu[name] = 0
                priceByMenu[name] = Int(price.substring(to: price.index(before: price.endIndex)).replacingOccurrences(of: ",", with: ""))
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getOrderList(_:)), name: NSNotification.Name(rawValue: "getOrder"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postOrder(_:)), name: NSNotification.Name(rawValue: "postOrder"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeTab(_:)), name: NSNotification.Name(rawValue: "changeTab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(touchedSubTableView(_:)), name: NSNotification.Name(rawValue: "touchedSubTableView"), object: nil)
        
        if (self.modelStore?.menu.count)! > 0 {
            let menu = (self.modelStore?.menu[0])!
            for (_, submenu) in menu {
                for (name, _) in submenu {
                    orderByMenu[name] = 0
                }
            }
        }
        
        self.networkOrder.getOrderList(buyerId: (self.modelStore?.id)!)
    }
    
    
    func getOrderList(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let orderInfo = userInfo["orderList"] as? [ModelOrders] else { return }
        self.orderList = orderInfo
        
        for order in self.orderList {
            for content in order.getContent() {
                orderByMenu[content]! += 1
            }
        }
        
        orderByMenuSorted = orderByMenu.sorted(by: { $0.1 > $1.1 })
        
        if orderByMenuSorted.count > 3 {
            var count = 0
            for i in (2 ..< orderByMenuSorted.count-1).reversed() {
                count += orderByMenuSorted[i].value
                orderByMenuSorted.removeLast()
            }
            orderByMenuSorted.append((key: "기타", value: count))
        }
        
        if (menuRankVC?.pieChartView != nil) {
            let indexPath = IndexPath(row: 0, section: 3)
            menuRankVC?.orderByMenuSorted = self.orderByMenuSorted
            menuRankVC?.setSegment()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func postOrder(_ notification: Notification) {
        
        self.networkOrder.getOrderList(buyerId: (self.modelStore?.id)!)
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
        if priceByMenu.count > 0 {
            let randomNo = arc4random_uniform(UInt32(priceByMenu.count))
            networkOrder.postOrder(sellderId: (modelStore?.id)!, buyerId: "hjtech", price: Array(priceByMenu.values)[Int(randomNo)], content: [Array(priceByMenu.keys)[Int(randomNo)]])
        }
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
            if let url = URL(string: (modelStore?.imgURL)!) {
                logoView.logoImage.af_setImage(withURL: url)
            } else {
                logoView.logoImage.image  = #imageLiteral(resourceName:"woowatech")
            }
            return logoView
        }
            
        if section == 2 {
            let rateView = Bundle.main.loadNibNamed("rateTableViewCell", owner: self, options: nil)?.first as! rateTableViewCell
            rateView.ratingValue.text = String(describing: floor((modelStore?.ratingValue)!*10)/10)
            return rateView
        }
        
        if section == 3 {
            let tapView = Bundle.main.loadNibNamed("segment", owner: self, options: nil)?.first as! segment
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
            cell.tabSubview.frame.size.height = (mukkaebieVC?.view.frame.height)!
            cell.tabSubviewHeightConstraint.constant = (mukkaebieVC?.view.frame.height)!
            mukkaebieVC?.view.frame = cell.tabSubview.frame
            cell.tabSubview.addSubview((mukkaebieVC?.view)!)
        case 1:
            cell.tabSubview.frame.size.height = (menuRankVC?.view.frame.height)!
            cell.tabSubviewHeightConstraint.constant = (menuRankVC?.view.frame.height)!
            menuRankVC?.view.frame = cell.tabSubview.frame
            cell.tabSubview.addSubview((menuRankVC?.view)!)
        case 2:
            cell.tabSubview.frame.size.height = (infoVC?.view.frame.height)!
            cell.tabSubviewHeightConstraint.constant = (infoVC?.view.frame.height)!
            infoVC?.view.frame = cell.tabSubview.frame
            cell.tabSubview.addSubview((infoVC?.view)!)
        case 3:
            cell.tabSubview.frame.size.height = (reviewVC?.view.frame.height)!
            cell.tabSubviewHeightConstraint.constant = (reviewVC?.view.frame.height)!
            reviewVC?.view.frame = cell.tabSubview.frame
            cell.tabSubview.addSubview((reviewVC?.view)!)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tabNumber {
        case 0:
            return 540
        case 1:
            return (menuRankVC?.view.frame.height)!
        case 2:
            return 667
        case 3:
            return (reviewVC?.view.frame.height)!
        default:
            break
        }
        return 0
    }
}
