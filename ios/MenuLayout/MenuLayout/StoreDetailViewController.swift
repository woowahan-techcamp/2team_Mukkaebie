//
//  StoreDetailViewController.swift
//  MenuLayout
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 hyeongjong. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController, UITabBarDelegate {
    
    var mukkabieViewController : MukkabieViewController?
    var menuViewController: MenuViewController?
    var infoViewController: InfoViewController?
    var reviewViewController: ReviewViewController?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var tabSubView: UIView!
    @IBOutlet weak var uppperBarView: UIView!
    @IBOutlet weak var scoreView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var mukkabieTabItem: UITabBarItem!
    @IBOutlet weak var menuTabItem: UITabBarItem!
    @IBOutlet weak var infoTabItem: UITabBarItem!
    @IBOutlet weak var reviewTabItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.delegate=self;

        mukkabieTabItem.tag = 0
        mukkabieTabItem.image = makeThumbnailFromText(text: "먹깨비")
        mukkabieTabItem.title = nil;
        
        menuTabItem.tag = 1
        menuTabItem.image = makeThumbnailFromText(text: "메뉴")
        menuTabItem.title = nil;
        
        infoTabItem.tag = 2
        infoTabItem.image = makeThumbnailFromText(text: "정보")
        infoTabItem.title = nil;
        
        reviewTabItem.tag = 3
        reviewTabItem.image = makeThumbnailFromText(text: "리뷰")
        reviewTabItem.title = nil;
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
            
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            mukkabieViewController = storyboard.instantiateViewController(withIdentifier: "mukkabieViewController") as? MukkabieViewController
            self.view.insertSubview((mukkabieViewController?.view.subviews[0])!, belowSubview: self.tabSubView)
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            menuViewController = storyboard.instantiateViewController(withIdentifier: "menuViewController") as? MenuViewController
            tabSubView.addSubview((menuViewController?.view.subviews[0])!)
            print((menuViewController?.view.subviews[0])!.frame.size.height)
            scrollView.contentSize.width = self.view.frame.size.width
            scrollView.contentSize.height = 1000
            tabView.sizeToFit()
            print(tabSubView.frame.size)
        case 2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            infoViewController = storyboard.instantiateViewController(withIdentifier: "infoViewController") as? InfoViewController
            self.tabSubView.addSubview((infoViewController?.view.subviews[0])!)
        case 3:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            reviewViewController = storyboard.instantiateViewController(withIdentifier: "reviewViewController") as? ReviewViewController
            self.view.insertSubview((reviewViewController?.view.subviews[0])!, belowSubview: self.tabSubView)
        default:
            break
            
        }
    }
    
    func makeThumbnailFromText(text: String) -> UIImage {
        // some variables that control the size of the image we create, what font to use, etc.
        
        struct LineOfText {
            var string: String
            var size: CGSize
        }
        
        let imageSize = CGSize(width: 60, height: 80)
        let fontSize: CGFloat = 13.0
        let fontName = "AppleSDGothicNeo-Bold"
        let font = UIFont(name: fontName, size: fontSize)!
        let lineSpacing = fontSize * 1.2
        
        // set up the context and the font
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let attributes = [NSFontAttributeName: font]
        
        // some variables we use for figuring out the words in the string and how to arrange them on lines of text
        
        let words = text.components(separatedBy: " ")
        
        var lines = [LineOfText]()
        var lineThusFar: LineOfText?
        
        // let's figure out the lines by examining the size of the rendered text and seeing whether it fits or not and
        // figure out where we should break our lines (as well as using that to figure out how to center the text)
        
        for word in words {
            let currentLine = lineThusFar?.string == nil ? word : "\(lineThusFar!.string) \(word)"
            let size = currentLine.size(attributes: attributes)
            if size.width > imageSize.width && lineThusFar != nil {
                lines.append(lineThusFar!)
                lineThusFar = LineOfText(string: word, size: word.size(attributes: attributes))
            } else {
                lineThusFar = LineOfText(string: currentLine, size: size)
            }
        }
        if lineThusFar != nil { lines.append(lineThusFar!) }
        
        // now write the lines of text we figured out above
        
        let totalSize = CGFloat(lines.count - 1) * lineSpacing + fontSize
        let topMargin = (imageSize.height - totalSize) / 2.0
        
        for (index, line) in lines.enumerated() {
            let x = (imageSize.width - line.size.width) / 2.0
            let y = topMargin + CGFloat(index) * lineSpacing
            line.string.draw(at: CGPoint(x: x, y: y), withAttributes: attributes)
        }
        
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
