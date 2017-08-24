//
//  StoreDetailViewController.swift
//  MenuLayout
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 hyeongjong. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController, UITabBarDelegate {
    
    var mukkaebieRankViewController : MukkaebieRankViewController?
    var menuViewController: MenuViewController?
//    var infoViewController: InfoViewController?
//    var reviewViewController: ReviewViewController?
    
    var modelStore : ModelStores?
    let networkOrder = NetworkOrder()
    var orderList = [ModelOrders]()
    var priceByMenu = [String:Int]()
    var orderByMenu = [String:Int]()
    var orderByMenuSorted = [(key: String, value: Int)]()
    
    @IBOutlet weak var meetPaymentLabel: UILabel!
    @IBOutlet weak var directPaymentLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var uppperBarView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tabSubView: UIView!
    
    @IBOutlet weak var mukkabieTabItem: UITabBarItem!
    @IBOutlet weak var menuTabItem: UITabBarItem!
    @IBOutlet weak var infoTabItem: UITabBarItem!
    @IBOutlet weak var reviewTabItem: UITabBarItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.tabBar.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        
        self.navigationItem.title = modelStore?.name
        
        meetPaymentLabel.layer.borderWidth = 1
        meetPaymentLabel.layer.borderColor = UIColor.white.cgColor
        meetPaymentLabel.layer.cornerRadius = meetPaymentLabel.frame.height/2
        
        directPaymentLabel.layer.borderWidth = 1
        directPaymentLabel.layer.borderColor = UIColor.white.cgColor
        directPaymentLabel.layer.cornerRadius = directPaymentLabel.frame.height/2
        
        tabBarInit()
        tabBarAppearanceInit()
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor(hexString: "EEEEEE").cgColor
        
        tabBar.selectedItem = tabBar.items![0] as UITabBarItem
        tabBar(tabBar, didSelect: mukkabieTabItem)
        

        /*for menu in (modelStore?.menu)! {
            orderByMenu[menu["foodNm"] as! String] = 0
            if Int(menu["foodPrice"] as! String) != 0 {
                priceByMenu[menu["foodNm"] as! String] = Int(menu["foodPrice"] as! String)
            }
        }
        }*/

        NotificationCenter.default.addObserver(self, selector: #selector(getOrderList(_:)), name: NSNotification.Name(rawValue: "getOrder"), object: nil)
        
        networkOrder.getOrderList(sellerId: (modelStore?.id)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func touchedShoppingCart(_ sender: Any) {
        if priceByMenu.count > 0 {
            let randomNo = arc4random_uniform(UInt32(priceByMenu.count))
            networkOrder.postOrder(sellderId: (modelStore?.id)!, buyerId: "hjtech", price: Array(priceByMenu.values)[Int(randomNo)], content: [Array(priceByMenu.keys)[Int(randomNo)]])
        }
    }
    
    func getOrderList(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let orderInfo = userInfo["orderList"] as? [ModelOrders] else { return }
        self.orderList = orderInfo

        for order in self.orderList {
            for content in order.content {
                orderByMenu[content]! += 1
            }
        }
    
        orderByMenuSorted = orderByMenu.sorted(by: { $0.1 > $1.1 })
        
        if orderByMenuSorted.count > 3 {
            var count = 0
            for i in (3 ..< orderByMenuSorted.count-1).reversed() {
                count += orderByMenuSorted[i].value
                orderByMenuSorted.removeLast()
            }
            orderByMenuSorted.append((key: "기타", value: count))
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        for child in self.childViewControllers {
            child.removeFromParentViewController()
        }
        
        for subview in tabSubView.subviews {
            subview.removeFromSuperview()
        }
        
        switch item.tag {
            
        case 0:
            let storyboard = UIStoryboard(name: "MukkaebieRank", bundle: nil)
            mukkaebieRankViewController = storyboard.instantiateViewController(withIdentifier: "MukkaebieRank") as? MukkaebieRankViewController
            addChildViewController(mukkaebieRankViewController!)
            
            tabSubView.addSubview((mukkaebieRankViewController?.view)!)
            mukkaebieRankViewController?.didMove(toParentViewController: self)
            
            adjustContentHeight(tabSubViewHeight: (mukkaebieRankViewController?.view.frame.size.height)!)
            adjustContentConstraint()
            break
            
        case 1:
            let storyboard = UIStoryboard(name: "MenuView", bundle: nil)
            menuViewController = storyboard.instantiateViewController(withIdentifier: "Menu") as? MenuViewController
            addChildViewController(menuViewController!)
            
            menuViewController?.orderByMenuSorted = orderByMenuSorted
            
            tabSubView.addSubview((menuViewController?.view)!)
            menuViewController?.didMove(toParentViewController: self)
                
            let tabSubviewHeight = (menuViewController?.view.frame.size.height)! - (menuViewController?.menuTableView.frame.size.height)! + (menuViewController?.menuTableView.contentSize.height)!
            adjustContentHeight(tabSubViewHeight: tabSubviewHeight)
            adjustContentConstraint()
            break
        case 2:
            break
        case 3:
            break
        default:
            break
        }
    }
    
    func tabBarInit() {
        mukkabieTabItem.tag = 0
        mukkabieTabItem.image = makeThumbnailFromText(text: "먹깨비", size: CGSize(width: tabBar.frame.width / CGFloat((tabBar.items?.count)!), height: tabBar.frame.height))
        mukkabieTabItem.title = nil;
        
        menuTabItem.tag = 1
        menuTabItem.image = makeThumbnailFromText(text: "메뉴", size: CGSize(width: tabBar.frame.width / CGFloat((tabBar.items?.count)!), height: tabBar.frame.height))
        menuTabItem.title = nil;
        
        infoTabItem.tag = 2
        infoTabItem.image = makeThumbnailFromText(text: "정보", size: CGSize(width: tabBar.frame.width / CGFloat((tabBar.items?.count)!), height: tabBar.frame.height))
        infoTabItem.title = nil;
        
        reviewTabItem.tag = 3
        reviewTabItem.image = makeThumbnailFromText(text: "리뷰", size: CGSize(width: tabBar.frame.width / CGFloat((tabBar.items?.count)!), height: tabBar.frame.height))
        reviewTabItem.title = nil;
    }
    
    func tabBarAppearanceInit() {
        UITabBar.appearance().tintColor = UIColor(white: 136/255, alpha: 1)
        UITabBar.appearance().barTintColor = UIColor.white
        
        //make image for selection - green rectagle
        UIGraphicsBeginImageContextWithOptions(CGSize(width: tabBar.frame.width / CGFloat((tabBar.items?.count)!), height: tabBar.frame.height), false, 0)
        UIColor.white.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: tabBar.frame.width / CGFloat((tabBar.items?.count)!
            ), height: tabBar.frame.height))
        UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1).setFill()
        UIRectFill(CGRect(x: 0, y: tabBar.frame.height - 5, width: tabBar.frame.width / CGFloat((tabBar.items?.count)!
            ), height: 5))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UITabBar.appearance().selectionIndicatorImage = image
    }
    
    func makeThumbnailFromText(text: String, size: CGSize) -> UIImage {
        // some variables that control the size of the image we create, what font to use, etc.
        
        let imageSize = size
        let fontSize: CGFloat = 15.0
        let fontName = "AppleSDGothicNeo-Bold"
        let font = UIFont(name: fontName, size: fontSize)!
        
        // set up the context and the font
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let attributes = [NSFontAttributeName: font]
        
        let x = (imageSize.width - text.size(attributes: attributes).width) / 2.0
        let y = (imageSize.height - fontSize) / 2.0
        text.draw(at: CGPoint(x: x, y: y), withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func adjustContentHeight(tabSubViewHeight: CGFloat) {
        tabSubView.frame.size.height = tabSubViewHeight
        tabView.frame.size.height = tabBar.frame.size.height+tabSubView.frame.size.height
        contentView.frame.size.height = tabView.frame.size.height+imageView.frame.size.height+scoreView.frame.size.height+uppperBarView.frame.size.height
        scrollView.contentSize.height = contentView.frame.size.height
    }
    
    func adjustContentConstraint() {
        if let constraint = (tabSubView.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = tabSubView.frame.size.height
            print(tabSubView.frame.size.height)
        }
        if let constraint = (tabView.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = tabView.frame.size.height
        }
        if let constraint = (contentView.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = contentView.frame.size.height
        }
    }
}
