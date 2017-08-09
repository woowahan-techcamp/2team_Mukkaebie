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
    
    let foodCategoryArray = ["치킨","중식","피자","한식","분식","족발,보쌈","야식","찜,탕","돈까스,회,일식","도시락","패스트푸드"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "치킨췤췤"
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(hexString: "3B342C")
        
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoreListTableViewCell
        cell.storeNameLabel.text = "중국성"
        cell.reviewNumaberLabel.text = "최근리뷰 10  최근사장님댓글 33"
        return cell
    }
    
}

extension StoreListViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoreListMenuBarCollectionViewCell
        cell.foodCategoryLabel.text = foodCategoryArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Double((foodCategoryArray[indexPath.row] as String).unicodeScalars.count) * 15 + 10
        
        
        let attString = NSAttributedString(string: foodCategoryArray[indexPath.row], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)])
        
        var r = attString.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 35),options: .usesLineFragmentOrigin, context: nil)
        
        r.size.height = 35
        r.size.width += 13
        
        print(r)
        return r.size
//        let width = Double((foodCategoryArray[indexPath.row] as String).unicodeScalars.count) * 15 + 10
//        return CGSize(width: width, height: 35)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
    
    
}
