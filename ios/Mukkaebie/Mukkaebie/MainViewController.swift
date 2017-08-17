//
//  FirstViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 3..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    let foodCategoryArray = ["치킨","중국집","피자","한식","족발,보쌈","야식","찜,탕","돈까스,회,일식","도시락","패스트푸드"]
    let foodCategoryArrayForURL = ["치킨","중국집","피자","한식","족발","야식","찜탕","일식","도시락","패스트푸드"]
    
    var selectionRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.allowsSelection = true
        mainCollectionView.allowsSelection = true
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showStoreList") {
            let storeListViewController = segue.destination as? StoreListViewController
            let indexPath = self.mainCollectionView.indexPathsForSelectedItems
            storeListViewController?.category = self.foodCategoryArrayForURL[(indexPath?[0].item)!]
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectionRow = indexPath.row
//        self.performSegue(withIdentifier: "storeList", sender: self)
//        
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 375, height: 128)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
        cell.categoryLabel.text = foodCategoryArray[indexPath.row]
        cell.categoryLabel.sizeToFit()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2 - 1
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

