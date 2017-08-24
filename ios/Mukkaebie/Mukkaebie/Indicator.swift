//
//  File.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 24..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class Indicator : UIView {

    let progressView = UIView()
    var activityIndicatorImageView = UIImageView()

    func showProgressView(view: UIView) -> UIImageView {
        
        let statusImage = #imageLiteral(resourceName: "indictorIcon")
        let activityImageView = UIImageView(image: statusImage)
        progressView.frame = view.frame
        progressView.center = CGPoint(x:view.bounds.width / 2, y:view.bounds.height / 2)
        progressView.backgroundColor = UIColor.white
        progressView.clipsToBounds = true
        
        activityImageView.animationImages = [#imageLiteral(resourceName: "indictorIcon"),#imageLiteral(resourceName: "indicarotIcon2"),#imageLiteral(resourceName: "indictorIcon"),#imageLiteral(resourceName: "indicarotIcon2"),#imageLiteral(resourceName: "indictorIcon"),#imageLiteral(resourceName: "indicarotIcon2")]
        activityImageView.animationDuration = 1;
        activityImageView.frame = CGRect(x: view.frame.width/2, y: view.frame.height/2, width: 77, height: 68)
        activityImageView.center = CGPoint(x: progressView.bounds.width/2, y: progressView.bounds.height/2)
        activityImageView.startAnimating()
        var alertTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: "stopAnimate", userInfo: nil, repeats: false)
        DispatchQueue.main.async() {
            self.progressView.addSubview(activityImageView)
            //            containerView.addSubview(progressView)
            view.addSubview(self.progressView)
            self.activityIndicatorImageView = activityImageView
        }
        
        return activityIndicatorImageView
    }

    func stopAnimate() {
        progressView.isHidden = true
    }

}
