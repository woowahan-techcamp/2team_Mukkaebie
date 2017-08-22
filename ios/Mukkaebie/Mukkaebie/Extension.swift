//
//  Extension.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIAlertController {
    func addimage(image: UIImage) {
        let maxSize = CGSize(width: 245, height: 300)
        let imageSize = image.size
        
        var ratio : CGFloat!
        if (imageSize.width > imageSize.height) {
            ratio = maxSize.width / imageSize.height
        } else {
            ratio = maxSize.height / imageSize.height
        }
        
        let scaledSize = CGSize(width: imageSize.width * ratio, height: imageSize.height * ratio)
        var resizedImage = image.imageWithSize(scaledSize)
        
        if imageSize.height > imageSize.width {
            let left = (maxSize.width - resizedImage.size.width) / 2
            resizedImage = resizedImage.withAlignmentRectInsets(UIEdgeInsetsMake(0, -left, 0, 0))
        }
        
        let imageAction = UIAlertAction(title: "", style: .default, handler: nil)
        imageAction.isEnabled = false
        imageAction.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imageAction)
    }
}

extension UIImage {
    func imageWithSize(_ size:CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth: CGFloat = size.width / self.size.width
        let aspectHeight : CGFloat = size.height / self.size.height
        let aspectRatio : CGFloat = min(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: scaledImageRect)
        
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaleImage!

    }
}

extension UIAlertController {
    func changeFont(view: UIView, font:UIFont) {
        for item in view.subviews {
            if item.isKind(of: UICollectionView.self) {
                let col = item as! UICollectionView
                for  row in col.subviews{
                    changeFont(view: row, font: font)
                }
            }
            if item.isKind(of: UILabel.self) {
                let label = item as! UILabel
                label.font = font
            }else {
                changeFont(view: item, font: font)
            }
            
        }
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        changeFont(view: self.view, font: font! )
    }
}


