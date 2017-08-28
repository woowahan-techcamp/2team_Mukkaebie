//
//  MukkaebieRankViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import AlamofireImage

class MukkaebieRankViewController: UIViewController {
    @IBOutlet weak var mukkaebieMessage: UILabel!
    @IBOutlet weak var mukkaebieCommentTextField: UITextField!
    
    @IBOutlet weak var firstMukkaebieImage: UIImageView!
    @IBOutlet weak var secondMukkaebieImage: UIImageView!
    @IBOutlet weak var thirdMukkaebieImage: UIImageView!
    
    @IBOutlet weak var firstAward: UIView!
    @IBOutlet weak var secondAward: UIView!
    @IBOutlet weak var thirdAward: UIView!
    
    @IBOutlet weak var firstBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstOrderLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondOrderLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdOrderLabel: UILabel!
    
    var mukkaebieImageList = [UIImageView]()
    var awardList = [UIView]()
    var bottomConstraintList = [NSLayoutConstraint]()
    var labelList = [UILabel]()
    var orderLabelList = [UILabel]()
    
    var orderByUserTop3 = [(key: String, value: Int)]()
    var mkbDictionaryArray = [[String : String]]()
    
    let imagePicker = UIImagePickerController()
    
    let networkMkb = NetworkMkb()
    var imgData : Data?
    var comment : String?
    
    var viewIsAnimated = false
    var imageCommentIsRequested = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame.size.height = view.frame.size.width * 118 / 75
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.navigationBar.isTranslucent = false
        
        mukkaebieImageList = [firstMukkaebieImage, secondMukkaebieImage, thirdMukkaebieImage]
        awardList = [firstAward, secondAward, thirdAward]
        bottomConstraintList = [firstBottomConstraint, secondBottomConstraint, thirdBottomConstraint]
        labelList = [firstLabel, secondLabel, thirdLabel]
        orderLabelList = [firstOrderLabel, secondOrderLabel, thirdOrderLabel]
        
        getMkbDictionrayList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !viewIsAnimated {
            firstBottomConstraint.constant -= firstAward.frame.height
            secondBottomConstraint.constant -= secondAward.frame.height
            thirdBottomConstraint.constant -= thirdAward.frame.height
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in 0..<orderByUserTop3.count {
            labelList[i].text = orderByUserTop3[i].key
            orderLabelList[i].text = "주문수 \(orderByUserTop3[i].value)"
        }
        
        if !imageCommentIsRequested {
            for i in 0..<orderByUserTop3.count {
                if let mkbIndex = mkbDictionaryArray.index(where: {$0["userId"] == orderByUserTop3[i].key}) {
                    if i == 0 && mkbDictionaryArray[mkbIndex]["mkbComment"] != nil {
                        mukkaebieCommentTextField.text = mkbDictionaryArray[mkbIndex]["mkbComment"]
                    }
                    if mkbDictionaryArray[mkbIndex]["imgUrl"] != nil {
                        mukkaebieImageList[i].af_setImage(withURL: URL(string:mkbDictionaryArray[mkbIndex]["imgUrl"]!)!, placeholderImage: #imageLiteral(resourceName: "woowatech"), filter: .none, progress: .none, progressQueue: DispatchQueue.global(), imageTransition: .noTransition, runImageTransitionIfCached: true, completion: nil)
                    }
                } else {
                    if i == 0 {
                        mukkaebieCommentTextField.text = "메세지를 입력해주세요"
                    }
                    mukkaebieImageList[i].af_setImage(withURL: URL(string: "https://unstats.un.org/unsd/trade/events/2015/abudhabi/img/no-pic.png")!, placeholderImage: #imageLiteral(resourceName: "woowatech"), filter: .none, progress: .none, progressQueue: DispatchQueue.global(), imageTransition: .noTransition, runImageTransitionIfCached: true, completion: nil)
                }
            }
            imageCommentIsRequested = true
        }
        
        if !viewIsAnimated {
            for i in 0..<orderByUserTop3.count {
                UIView.animate(withDuration: 1.5, delay: TimeInterval(i + 1), usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.bottomConstraintList[i].constant += self.awardList[i].frame.height
                    self.view.layoutSubviews()
                }, completion: nil)
            }
            viewIsAnimated = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getOrderByUserSorted() {
        let orderByUserSorted = Store.sharedInstance.specificStore.orderByUser.sorted(by: { $0.1 > $1.1 })
        
        for i in orderByUserSorted.count > 3 ? 0..<3 : 0..<orderByUserSorted.count {
            orderByUserTop3.append(orderByUserSorted[i])
        }
    }
    
    func getMkbDictionrayList() {
        for mkb in (Store.sharedInstance.specificStore?.mkb)!.reversed() {
            for user in orderByUserTop3 {
                if mkb["userId"] == user.key {
                    if !mkbDictionaryArray.contains(where: { $0["userId"] == user.key }) {
                        mkbDictionaryArray.append(mkb)
                        if mkbDictionaryArray.count == orderByUserTop3.count {
                            mkbDictionaryArray.sort(by: {mkb1, mkb2 in orderByUserTop3.index(where: {$0.key == mkb1["userId"]!})! < orderByUserTop3.index(where: {$0.key == mkb2["userId"]!})!})
                            return
                        }
                    }
                }
            }
        }
    }
    
    func postComment(userId: String, mkbComment: String){
        if imgData == nil {
            if let mkbIndex = mkbDictionaryArray.index(where: {$0["userId"] == userId}) {
                let mkb = mkbDictionaryArray[mkbIndex]
                if mkb["userId"] == userId && mkb["imgUrl"] != nil{
                    networkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: mkbComment, imgUrl: mkb["imgUrl"]!)
                } else {
                    networkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: mkbComment, imgUrl: "https://unstats.un.org/unsd/trade/events/2015/abudhabi/img/no-pic.png")
                }
            }
            networkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: mkbComment, imgUrl: "https://unstats.un.org/unsd/trade/events/2015/abudhabi/img/no-pic.png")
        } else {
            networkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: mkbComment, imgData: imgData!)
        }
    }
    
    func postImgData(userId: String, imgData: Data) {
        if comment == nil {
            if let mkbIndex = mkbDictionaryArray.index(where: {$0["userId"] == userId}) {
                let mkb = mkbDictionaryArray[mkbIndex]
                if mkb["userId"] == userId && mkb["mkbComment"] != nil && mkb["mkbComment"] != "" {
                    networkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: mkb["mkbComment"]!, imgData: imgData)
                } else {
                    networkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: "먹깨비가 되었다!", imgData: imgData)
                }
            } else {
                networkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: "먹깨비가 되었다!", imgData: imgData)
            }
        } else {
            networkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: comment!, imgData: imgData)
        }
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        let mkbComment = sender.text
        comment = mkbComment
        postComment(userId: "hjtech", mkbComment: mkbComment!)
    }
    
    @IBAction func firstProfileImagePicker(_ sender: Any) {
        self.view.window?.rootViewController?.present(imagePicker, animated: false, completion: nil)
    }
}

extension MukkaebieRankViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.childViewControllers.count == 2 {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
            let statusBarColor = UIColor(hexString: "3B342C")
            statusBarView.backgroundColor = statusBarColor
            viewController.view.addSubview(statusBarView)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imgData = UIImageJPEGRepresentation(image, 0.1)
            firstMukkaebieImage.image = image
            self.imgData = imgData
            postImgData(userId: "hjtech", imgData: imgData!)
        } else{
            print("something went wrong")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
