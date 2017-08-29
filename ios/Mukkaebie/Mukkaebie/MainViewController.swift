//
//  FirstViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 3..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let launchScreenView = UINib(nibName: "LaunchView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! LaunchScreen

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
        let buttonArray = [#imageLiteral(resourceName: "ios_1_20140423"), #imageLiteral(resourceName: "ios_2_20140423"), #imageLiteral(resourceName: "ios_3_20140423"), #imageLiteral(resourceName: "ios_38_20170420"),#imageLiteral(resourceName: "ios_4_20140423") ,#imageLiteral(resourceName: "ios_5_20140423"),#imageLiteral(resourceName: "ios_6_20140423"),#imageLiteral(resourceName: "ios_10_20140423"), #imageLiteral(resourceName: "ios_9_20140423"),#imageLiteral(resourceName: "ios_7_20140423")]
    
    let selectedButtonArray = [#imageLiteral(resourceName: "ios_1_On_20140423"),#imageLiteral(resourceName: "ios_2_On_20140423"),#imageLiteral(resourceName: "ios_3_On_20140423"),#imageLiteral(resourceName: "ios_38_On_20170420"),#imageLiteral(resourceName: "ios_4_On_20140423"),#imageLiteral(resourceName: "ios_5_On_20140423"),#imageLiteral(resourceName: "ios_6_On_20140423"),#imageLiteral(resourceName: "ios_10_On_20140423"),#imageLiteral(resourceName: "ios_9_On_20140423"),#imageLiteral(resourceName: "ios_7_On_20140423")]
    
    var selectionRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchScreenView.initLaunch(target: self)
        launchScreenView.startLaunch(target: self)
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.allowsSelection = true
        

        navigationController?.setNavigationBarHidden(true, animated: false)
        mainCollectionView.reloadData()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        launchScreenView.animate()
        navigationController?.setNavigationBarHidden(true, animated: false)
//        self.tabBarController?.tabBar.isHidden = false
        if let indexPathForSelect = self.mainCollectionView.indexPathsForSelectedItems {
            if indexPathForSelect.count > 0 {
            self.mainCollectionView.deselectItem(at: indexPathForSelect[0], animated: true)
            }
        }

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showStoreList") {
            let storeListViewController = segue.destination as? StoreListViewController
            let indexPath = self.mainCollectionView.indexPathsForSelectedItems
            storeListViewController?.category = foodCategoryArrayForURL[(indexPath?[0].item)!]
        }
    }

}


extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @available(iOS 6.0, *)

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind:kind , withReuseIdentifier: "header", for: indexPath) as? MainHeaderCollectionReusableView
        return header!

    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
        cell.buttonImage.image = buttonArray[indexPath.row]
        cell.buttonImage.highlightedImage = selectedButtonArray[indexPath.row]

        return cell

    }

    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

