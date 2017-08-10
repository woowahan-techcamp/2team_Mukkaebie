//
//  StoreDetailViewController.swift
//  MenuLayout
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 hyeongjong. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController, UITabBarDelegate {
    
//    var mukkaebieRankViewController : MukkaebieRankViewController?
//    var menuViewController: MenuViewController?
//    var infoViewController: InfoViewController?
//    var reviewViewController: ReviewViewController?
    
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
        self.tabBar.delegate=self;
        
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
        
        //change icon and title color
        UITabBar.appearance().tintColor = UIColor(white: 136/255, alpha: 1)
        
        //change background default color
        UITabBar.appearance().barTintColor = UIColor.white
        
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
        
        self.tabBarController?.tabBar.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
            
        case 0:
            let storyboard = UIStoryboard(name: "MukkaebieRank", bundle: nil)
            let mukkaebieRankViewController = storyboard.instantiateViewController(withIdentifier: "MukkaebieRank") as? MukkaebieRankViewController
            addChildViewController(mukkaebieRankViewController!)
            
            
            tabSubView.addSubview((mukkaebieRankViewController?.view)!)
            mukkaebieRankViewController?.didMove(toParentViewController: self)
            
            tabSubView.frame.size.height = (mukkaebieRankViewController?.view.frame.size.height)!
            tabView.frame.size.height = tabBar.frame.size.height+tabSubView.frame.size.height
            contentView.frame.size.height = tabView.frame.size.height+imageView.frame.size.height+scoreView.frame.size.height+uppperBarView.frame.size.height
            
            scrollView.contentSize.width = contentView.frame.size.width
            scrollView.contentSize.height = contentView.frame.size.height
            
//            let storyboard = UIStoryboard(name: "StoreDetail", bundle: nil)
//            mukkabieViewController = storyboard.instantiateViewController(withIdentifier: "mukkabieViewController") as? MukkabieViewController
//            tabSubView.addSubview((mukkabieViewController?.view.subviews[0])!)
//            
//            tabSubView.frame.size.height = (mukkabieViewController?.view.frame.size.height)!
//            tabView.frame.size.height = tabBar.frame.size.height+tabSubView.frame.size.height
//            contentView.frame.size.height = tabView.frame.size.height+imageView.frame.size.height+scoreView.frame.size.height+uppperBarView.frame.size.height
            
            scrollView.contentSize.width = contentView.frame.size.width
            scrollView.contentSize.height = contentView.frame.size.height
        case 1:
//            let storyboard = UIStoryboard(name: "StoreDetail", bundle: nil)
//            menuViewController = storyboard.instantiateViewController(withIdentifier: "menuViewController") as? MenuViewController
//            tabSubView.addSubview((menuViewController?.view.subviews[0])!)
//            
//            tabSubView.frame.size.height = (menuViewController?.view.frame.size.height)!
//            tabView.frame.size.height = tabBar.frame.size.height+tabSubView.frame.size.height
//            contentView.frame.size.height = tabView.frame.size.height+imageView.frame.size.height+scoreView.frame.size.height+uppperBarView.frame.size.height
            
            scrollView.contentSize.width = contentView.frame.size.width
            scrollView.contentSize.height = contentView.frame.size.height
        case 2:
//            let storyboard = UIStoryboard(name: "StoreDetail", bundle: nil)
//            infoViewController = storyboard.instantiateViewController(withIdentifier: "infoViewController") as? InfoViewController
//            tabSubView.addSubview((infoViewController?.view.subviews[0])!)
//            tabSubView.frame.size.height = (infoViewController?.view.frame.size.height)!
//            tabView.frame.size.height = tabBar.frame.size.height+tabSubView.frame.size.height
//            contentView.frame.size.height = tabView.frame.size.height+imageView.frame.size.height+scoreView.frame.size.height+uppperBarView.frame.size.height
            
            scrollView.contentSize.width = contentView.frame.size.width
            scrollView.contentSize.height = contentView.frame.size.height
        case 3:
//            let storyboard = UIStoryboard(name: "StoreDetail", bundle: nil)
//            reviewViewController = storyboard.instantiateViewController(withIdentifier: "reviewViewController") as? ReviewViewController
//            tabSubView.addSubview((reviewViewController?.view.subviews[0])!)
//            
//            tabSubView.frame.size.height = (reviewViewController?.view.frame.size.height)!
//            tabView.frame.size.height = tabBar.frame.size.height+tabSubView.frame.size.height
//            contentView.frame.size.height = tabView.frame.size.height+imageView.frame.size.height+scoreView.frame.size.height+uppperBarView.frame.size.height
            
            scrollView.contentSize.width = contentView.frame.size.width
            scrollView.contentSize.height = contentView.frame.size.height
        default:
            break
            
        }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
