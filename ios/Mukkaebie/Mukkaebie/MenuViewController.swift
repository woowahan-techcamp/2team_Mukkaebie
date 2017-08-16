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
    
    var orderByMenu = [String:Int]()
    
    let item1 = MenuViewModelItem(sectionTitle: "치킨", rowCount: 4, isCollapsed: false)
    let item2 = MenuViewModelItem(sectionTitle: "양념", rowCount: 1, isCollapsed: false)
    let item3 = MenuViewModelItem(sectionTitle: "양념", rowCount: 1, isCollapsed: false)
    let item4 = MenuViewModelItem(sectionTitle: "양념", rowCount: 1, isCollapsed: false)
    let item5 = MenuViewModelItem(sectionTitle: "양념", rowCount: 1, isCollapsed: false)
    let item6 = MenuViewModelItem(sectionTitle: "양념", rowCount: 1, isCollapsed: false)
    var items: Array<MenuViewModelItem> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
        
        items = [item1, item2, item3, item4, item5, item6]
        
        pieChartView.segments = [
            Segment(color: UIColor(red: 251/255, green: 136/255, blue: 136/255, alpha: 1), value: 57, title: "간지치킨"),
            Segment(color: UIColor(red: 251/255, green: 229/255, blue: 136/255, alpha: 1), value: 30, title: "후라이드"),
            Segment(color: UIColor(red: 232/255, green: 166/255, blue: 93/255, alpha: 1), value: 25, title: "고추치킨"),
            Segment(color: UIColor(white: 179/255, alpha: 1), value: 25, title: "기타")
            ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    func touchedArrowLabel(gestureRecognizer: UIGestureRecognizer) {
        if items[(gestureRecognizer.view?.tag)!].isCollapsible {
            
            // Toggle collapse
            let collapsed = items[(gestureRecognizer.view?.tag)!].isCollapsed
            items[(gestureRecognizer.view?.tag)!].isCollapsed = !collapsed
            
            //caculate new height for table view
            let heightOfCell: CGFloat = 44
            var expectedHeightOfTable: CGFloat = 0
            
            for i in 0..<menuTableView.numberOfSections {
                //header section
                let heightOfHeaderView: CGFloat = 30
                expectedHeightOfTable = expectedHeightOfTable + heightOfHeaderView
                
                //content section
                if i != (gestureRecognizer.view?.tag)! {
                    expectedHeightOfTable = expectedHeightOfTable + heightOfCell * CGFloat(menuTableView.numberOfRows(inSection: i))
                } else if i == (gestureRecognizer.view?.tag)! && collapsed == true {
                    expectedHeightOfTable = expectedHeightOfTable + heightOfCell * CGFloat(items[i].rowCount)
                }
            }
            
            //update height of table view
            menuTableView.frame = CGRect(x: menuTableView.frame.origin.x, y: menuTableView.frame.origin.y, width: menuTableView.frame.size.width, height: expectedHeightOfTable)
            menuTableView.reloadData()
        }
    }
}


