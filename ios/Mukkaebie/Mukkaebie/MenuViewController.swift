//
//  MenuViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet var noOrderView: UIView!
    
    var modelStore : ModelStores?
    var noOrder = false
    var orderByMenuSorted = [(key: String, value: Int)]()

    var top3Array = [(key:String, value:String)]()
    
    let colors = [UIColor(red: 251/255, green: 136/255, blue: 136/255, alpha: 1), UIColor(red: 251/255, green: 229/255, blue: 136/255, alpha: 1), UIColor(red: 232/255, green: 166/255, blue: 93/255, alpha: 1), UIColor(white: 179/255, alpha: 1)]
    
    var items: Array<MenuViewModelItem> = []
    var menus: [[(key: String, value: String)]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
        setSegment()
        
        self.menuTableView.reloadData()
        view.frame.size.height = view.frame.size.height - menuTableView.frame.size.height + menuTableView.contentSize.height
    }
    
    func setSegment() {
        if noOrder {
            pieChartView.addSubview(noOrderView)
        } else {
            pieChartView.segments = []
            for subview in pieChartView.subviews {
                subview.removeFromSuperview()
            }
            
            var orderCountArray = [Int]()
            var menuPercentArray = [String]()
            var totalOrder = Int()
            
            for i in 0 ..< orderByMenuSorted.count {
                totalOrder += orderByMenuSorted[i].value
            }
            
            let menusArray = menus.flatMap { $0 }
            for i in 0 ..< orderByMenuSorted.count {
                for j in 0 ..< menusArray.count {
                    if menusArray[j].key == orderByMenuSorted[i].key {
                        top3Array.append(menusArray[j])
                    }
                }
            }
            
            for i in 0 ..< orderByMenuSorted.count {
                orderCountArray.append(orderByMenuSorted[i].value)
                menuPercentArray.append(String(floor((Double(orderCountArray[i]) / Double(totalOrder) * 100)*10)/10))
                let titleButton = "\(orderByMenuSorted[i].key) " + "\((menuPercentArray[i]))%"
                let segment = Segment(color: colors[i], value: CGFloat(orderByMenuSorted[i].value), title: titleButton, price: top3Array.count > i ? top3Array[i].value : "0원")
                pieChartView.segments.append(segment)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuOrder" {
            if let indexPath = self.menuTableView.indexPathForSelectedRow {
                let cartPaymentcontroller = segue.destination as! CartPaymentViewController
                cartPaymentcontroller.menuName = self.menus[indexPath.section][indexPath.row].key
                cartPaymentcontroller.menuPrice = self.menus[indexPath.section][indexPath.row].value
                cartPaymentcontroller.modelStore = self.modelStore!
            }
        }
    }
    
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = self.items[section]
        if item.isCollapsible && item.isCollapsed {
            return 0
        }
        return item.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        cell.menuLabel.text = menus[indexPath.section][indexPath.row].key
        cell.priceLabel.text = menus[indexPath.section][indexPath.row].value
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! MenuTableViewHeader
        
        //set header parameter
        header.frame = CGRect(x:0, y:0, width: 375, height: 30)
        header.heightAnchor.constraint(equalToConstant: 30).isActive = true
        header.backgroundColor = UIColor(red:1, green:1, blue:1, alpha: 1)
        header.categoryLabel.text = items[section].sectionTitle
        header.setCollapsed(collapsed: items[section].isCollapsed)
        
        //delete older gestureRecognizer
        if header.gestureRecognizers != nil {
            for gestureReconizer in header.gestureRecognizers! {
                header.removeGestureRecognizer(gestureReconizer)
            }
        }
        
        //add new gestureRecognizer to content view of header
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchedArrowLabel))
        tapRecognizer.delegate = self as? UIGestureRecognizerDelegate
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        header.contentView.addGestureRecognizer(tapRecognizer)
        
        //set tag for content view of header
        header.contentView.tag = section
        
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7
    }
    
    func touchedArrowLabel(gestureRecognizer: UIGestureRecognizer) {
        if items[(gestureRecognizer.view?.tag)!].isCollapsible {
            
            // Toggle collapse
            let collapsed = items[(gestureRecognizer.view?.tag)!].isCollapsed
            items[(gestureRecognizer.view?.tag)!].isCollapsed = !collapsed
            
            //caculate new height for table view
            let heightOfCell: CGFloat = 44
            var expectedHeightOfTable: CGFloat = 0
            let heightOfHeaderView: CGFloat = 30
            let heightOfFooterView: CGFloat = 7
            for i in 0..<menuTableView.numberOfSections {
                //header section
                
                expectedHeightOfTable = expectedHeightOfTable + heightOfHeaderView
                
                //content section
                if i != (gestureRecognizer.view?.tag)! {
                    expectedHeightOfTable = expectedHeightOfTable + heightOfCell * CGFloat(menuTableView.numberOfRows(inSection: i))
                } else if i == (gestureRecognizer.view?.tag)! && collapsed == true {
                    expectedHeightOfTable = expectedHeightOfTable + heightOfCell * CGFloat(items[i].rowCount)
                }
                expectedHeightOfTable = expectedHeightOfTable + heightOfFooterView
            }
            
            //update height of table view
            view.frame.size.height = view.frame.size.height - menuTableView.frame.size.height + expectedHeightOfTable
            menuTableView.frame = CGRect(x: menuTableView.frame.origin.x, y: menuTableView.frame.origin.y, width: menuTableView.frame.size.width, height: expectedHeightOfTable)
            menuTableView.reloadData()
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "touchedSubTableView"), object: nil, userInfo: nil)
    }
}


