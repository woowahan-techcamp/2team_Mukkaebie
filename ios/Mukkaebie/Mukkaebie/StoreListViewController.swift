//
//  StoreListViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class StoreListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    let networkStore = NetworkStore()
    
    let foodCategoryArray = ["치킨","중식","피자","한식","분식","족발,보쌈","야식","찜,탕","돈까스,회,일식","도시락","패스트푸드"]
//    var storeList = [[String : Any]]()
    var storeList = [ModelStores]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "치킨췤췤"
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(hexString: "3B342C")
        tableView.allowsSelection = true
        collectionView.allowsSelection = true
        
        self.navigationController?.navigationBar.isHidden = false
        networkStore.getStoreList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getStoreList(_:)), name: NSNotification.Name(rawValue: "getStore"), object: nil)
        
    }
    
    func getStoreList(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let storeInfo = userInfo["storeList"] as? [ModelStores] else { return }
            self.storeList = storeInfo
        tableView.reloadData()
        }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension StoreListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoreListTableViewCell
        cell.storeNameLabel.text = storeList[indexPath.row].name as String
        
        
        
        cell.reviewNumaberLabel.text = "최근리뷰 10  최근사장님댓글 33"
        return cell
    }
    
}

extension StoreListViewController : UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoreListMenuBarCollectionViewCell
        cell.foodCategoryLabel.text = foodCategoryArray[indexPath.row]
        return cell
    }
    
    
}

extension StoreListViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (foodCategoryArray[indexPath.row] as NSString).size(attributes: nil)
        return CGSize(width: size.width * 1.5 , height: 35)
        
        //        let width = Double((foodCategoryArray[indexPath.row] as String).unicodeScalars.count) * 15 + 10
        //        return CGSize(width: width, height: 35)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}
