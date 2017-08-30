//
//  MukkaebieRankViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import AlamofireImage

class MukkaebieRankViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var mukkaebieMessage: UILabel!
    @IBOutlet weak var mukkaebieCommentTextField: UITextField!
    
    @IBOutlet weak var firstImageButton: UIButton!
    @IBOutlet weak var sencondImageButton: UIButton!
    @IBOutlet weak var thirdImageButton: UIButton!
    
    var imageButtonList = [UIButton]()
    
    @IBOutlet weak var firstMukkaebieImage: UIImageView!
    @IBOutlet weak var secondMukkaebieImage: UIImageView!
    @IBOutlet weak var thirdMukkaebieImage: UIImageView!
    
    @IBOutlet weak var firstAward: UIView!
    @IBOutlet weak var secondAward: UIView!
    @IBOutlet weak var thirdAward: UIView!
    
    @IBOutlet weak var particleImageView: UIImageView!
    
    @IBOutlet weak var firstBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var particleTopConstraint: NSLayoutConstraint!
    
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
        UIApplication.shared.statusBarStyle = .lightContent
        
        imageButtonList = [firstImageButton,sencondImageButton,thirdImageButton]
        mukkaebieImageList = [firstMukkaebieImage, secondMukkaebieImage, thirdMukkaebieImage]
        awardList = [firstAward, secondAward, thirdAward]
        bottomConstraintList = [firstBottomConstraint, secondBottomConstraint, thirdBottomConstraint]
        labelList = [firstLabel, secondLabel, thirdLabel]
        orderLabelList = [firstOrderLabel, secondOrderLabel, thirdOrderLabel]
        
        mukkaebieCommentTextField.delegate = self
        mukkaebieCommentTextField.isEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
        
        
        for i in 0..<imageButtonList.count {
            imageButtonList[i].isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !viewIsAnimated && orderByUserTop3.count > 0 {
            firstBottomConstraint.constant -= firstAward.frame.height
            secondBottomConstraint.constant -= secondAward.frame.height
            thirdBottomConstraint.constant -= thirdAward.frame.height
            particleTopConstraint.constant += particleImageView.frame.height
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        for (index,val) in orderByUserTop3.enumerated() {
            if index == 0 && val.key == User.sharedInstance.user.id {
                mukkaebieCommentTextField.isEnabled = true
                imageButtonList[index].isHidden = false
            }

            else if val.key == User.sharedInstance.user.id {
                mukkaebieCommentTextField.isEnabled = false
                imageButtonList[index].isHidden = false
            }
        }
        
        for i in 0..<orderByUserTop3.count {
            labelList[i].text = orderByUserTop3[i].key
            orderLabelList[i].text = "주문수 \(orderByUserTop3[i].value)"
        }
        
        if !imageCommentIsRequested && orderByUserTop3.count > 0 {
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
                        mukkaebieCommentTextField.placeholder = "먹깨비만 남길 수 있는 영광의 한마디!"
                    }
                    mukkaebieImageList[i].af_setImage(withURL: URL(string: "http://52.78.27.108:3000/uploads/profileImage-1503980151599.jpg")!, placeholderImage: #imageLiteral(resourceName: "woowatech"), filter: .none, progress: .none, progressQueue: DispatchQueue.global(), imageTransition: .noTransition, runImageTransitionIfCached: true, completion: nil)
                }
            }
            imageCommentIsRequested = true
        }
        
        
        if !viewIsAnimated && orderByUserTop3.count > 0 {
            for i in 0..<orderByUserTop3.count {
                UIView.animate(withDuration: 1.5, delay: TimeInterval(i + 1), usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.bottomConstraintList[i].constant += self.awardList[i].frame.height
                    self.view.layoutSubviews()
                }, completion: nil)
            }
            UIView.animate(withDuration: 4, delay: 3, options: .curveEaseInOut, animations: {
                self.particleTopConstraint.constant -= self.particleImageView.frame.height * 2
                self.view.layoutSubviews()
            }, completion: nil)
            viewIsAnimated = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getOrderByUserSorted() {
        orderByUserTop3 = [(key: String, value: Int)]()
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
                    NetworkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: mkbComment, imgUrl: mkb["imgUrl"]!)
                } else {
                    NetworkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: mkbComment, imgUrl: "http://52.78.27.108:3000/uploads/profileImage-1503980151599.jpg")
                }
            }
            NetworkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: mkbComment, imgUrl: "http://52.78.27.108:3000/uploads/profileImage-1503980151599.jpg")
        } else {
            NetworkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: mkbComment, imgData: imgData!)
        }
    }
    
    func postImgData(userId: String, imgData: Data) {
        if comment == nil {
            if let mkbIndex = mkbDictionaryArray.index(where: {$0["userId"] == userId}) {
                let mkb = mkbDictionaryArray[mkbIndex]
                if mkb["userId"] == userId && mkb["mkbComment"] != nil && mkb["mkbComment"] != "" {
                    NetworkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: mkb["mkbComment"]!, imgData: imgData)
                } else {
                    NetworkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: "먹깨비가 되었다!", imgData: imgData)
                }
            } else {
                NetworkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: "먹깨비가 되었다!", imgData: imgData)
            }
        } else {
            NetworkMkb.postMkb(storeId: (Store.sharedInstance.specificStore?.id)!, userId: userId, mkbComment: comment!, imgData: imgData)
        }
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        let mkbComment = sender.text
        comment = mkbComment
        postComment(userId: User.sharedInstance.user.id, mkbComment: mkbComment!)
        mukkaebieCommentTextField.endEditing(true)
        
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        mukkaebieCommentTextField.resignFirstResponder()
//        return true;
//    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        mukkaebieCommentTextField.resignFirstResponder()
        self.parent?.view.endEditing(true)
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        mukkaebieCommentTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func firstProfileImagePicker(_ sender: Any) {
        self.view.window?.rootViewController?.present(imagePicker, animated: false, completion: nil)
    }
}

extension MukkaebieRankViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.childViewControllers.count == 2 {
            UIApplication.shared.statusBarStyle = .lightContent
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
            postImgData(userId: User.sharedInstance.user.id, imgData: imgData!)
        } else{
            print("something went wrong")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
