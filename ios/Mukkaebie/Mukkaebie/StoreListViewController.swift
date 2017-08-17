//
//  StoreListViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import AlamofireImage

class StoreListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    let foodCategoryArray = ["치킨","중식","피자","한식","족발,보쌈","야식","찜,탕","돈까스,회,일식","도시락","패스트푸드"]
    let foodCategoryArrayForURL = ["치킨","중국집","피자","한식","족발","야식","찜탕","일식","도시락","패스트푸드"]
    
    var category : String!
    let networkStore = NetworkStore()
    var storeList = [ModelStores]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "치킨췤췤"
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.allowsSelection = true
        collectionView.allowsSelection = true
        
        self.navigationController?.navigationBar.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(getStoreList(_:)), name: NSNotification.Name(rawValue: "getStore"), object: nil)
        
        networkStore.getStoreList(category: category)
    }
    
    func getStoreList(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let storeInfo = userInfo["storeList"] as? [ModelStores] else { return }
        self.storeList = storeInfo
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if collectionView.subviews.filter({$0.tag == -1}).count == 0 {
            let indexPath = IndexPath(row: foodCategoryArrayForURL.index(of: category)!, section: 0)
            let width = collectionView.cellForItem(at: indexPath) != nil ? collectionView.cellForItem(at: indexPath)?.frame.size.width : self.collectionView(collectionView, cellForItemAt: indexPath).frame.size.width
            let selector = UIView(frame: CGRect(x: 0, y: 30, width: width!, height: 5))
            selector.backgroundColor = .white
            selector.tag = -1
            collectionView.addSubview(selector)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.left)
            collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStoreDetail"{
            if let storeTestViewController = segue.destination as? StoreTestViewController{
                let indexPath = self.tableView.indexPathForSelectedRow
                storeTestViewController.modelStore = self.storeList[(indexPath?.row)!]
            }
        }
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
        let url = URL(string: storeList[indexPath.row].imgURL)!
        
        cell.storeLogoImage.af_setImage(withURL: url)
        cell.reviewNumaberLabel.text = "최근리뷰 10  최근사장님댓글 33"
        return cell
    }
    
}

extension StoreListViewController : UICollectionViewDataSource, UICollectionViewDelegate {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoreListMenuBarCollectionViewCell
        cell.foodCategoryLabel.text = foodCategoryArray[indexPath.row]
        cell.foodCategoryLabel.frame.size = cell.frame.size
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        
        let selector = collectionView.subviews.filter({$0.tag == -1})
        
        let cell = collectionView.cellForItem(at: indexPath) != nil ? collectionView.cellForItem(at: indexPath) : self.collectionView(collectionView, cellForItemAt: indexPath)
        
        if selector.count == 1 {
            selector[0].frame.size.width = (cell?.frame.width)!
            let selectorStart = cell?.frame.minX
            UIView.animate(withDuration: 0.3, animations: {
                        selector[0].frame.origin.x = selectorStart!
            })
        }
        
        networkStore.getStoreList(category: foodCategoryArrayForURL[foodCategoryArray.index(of: (cell as! StoreListMenuBarCollectionViewCell).foodCategoryLabel.text!)!])
    }
    
}

extension StoreListViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (foodCategoryArray[indexPath.row] as NSString).size(attributes: nil)
        return CGSize(width: size.width+50, height: 35)
        
        //        let width = Double((foodCategoryArray[indexPath.row] as String).unicodeScalars.count) * 15 + 10
        //        return CGSize(width: width, height: 35)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}
