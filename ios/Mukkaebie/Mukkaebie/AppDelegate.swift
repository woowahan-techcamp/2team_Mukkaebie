//
//  AppDelegate.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 3..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import Fingertips

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let mainViewController = window?.rootViewController
        window = MBFingerTipWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = mainViewController!
        window!.makeKeyAndVisible()
        (window as? MBFingerTipWindow)?.alwaysShowTouches = true
        (window as? MBFingerTipWindow)?.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        (window as? MBFingerTipWindow)?.fillColor = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 0.8)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(hexString: "3B342C")
        statusBarView.backgroundColor = statusBarColor
        window?.addSubview(statusBarView)
        
        
        
        let navigationBarApearace = UINavigationBar.appearance()
        navigationBarApearace.tintColor = UIColor(hexString: "0xffffff")
        navigationBarApearace.barTintColor = UIColor(hexString: "3B342C")
        navigationBarApearace.clipsToBounds = true
        
        let backButtonImage = #imageLiteral(resourceName: "backButton").stretchableImage(withLeftCapWidth: 20, topCapHeight: 10)

        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
        
        navigationBarApearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor(hexString: "F06F23")
        tabBarAppearance.barTintColor = UIColor(hexString: "000000")
        tabBarAppearance.unselectedItemTintColor = UIColor.white
        let tabBarItemAppearance = UITabBarItem.appearance()
        tabBarItemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(hexString: "F06F23")], for: .selected)
        
        tabBarItemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NetworkStore.getStoreList { (storeList) in
            Store.sharedInstance.allStores = storeList
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "finishLaunch"), object: nil, userInfo: ["storeList":storeList])
        }
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }




}

