//
//  MukkaebieRankViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import AlamofireImage

class MukkaebieRankViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    
    var modelStore : ModelStores?
    var orderByUserTop3 = [(key: String, value: Int)]()
    
    var postImgData : Data?
    var postComment : String?
    let imagePicker = UIImagePickerController()
    
    let networkMkb = NetworkMkb()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame.size.height = view.frame.size.width * 118 / 75
        //view.frame.size.height = 565p
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.navigationBar.isTranslucent = false
        
//        staticHeight.constant -= gradeStackView.frame.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstBottomConstraint.constant -= firstAward.frame.height
        secondBottomConstraint.constant -= secondAward.frame.height
        thirdBottomConstraint.constant -= thirdAward.frame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if orderByUserTop3.count > 0 {
            firstLabel.text = orderByUserTop3[0].key
            firstOrderLabel.text = "주문수 \(orderByUserTop3[0].value)"
            if orderByUserTop3.count > 1 {
                secondLabel.text = orderByUserTop3[1].key
                secondOrderLabel.text = "주문수 \(orderByUserTop3[1].value)"
                if orderByUserTop3.count > 2 {
                    thirdLabel.text = orderByUserTop3[2].key
                    thirdOrderLabel.text = "주문수 \(orderByUserTop3[2].value)"
                }
            }
        }
        
        if firstMukkaebieImage.image == nil && secondMukkaebieImage.image == nil && thirdMukkaebieImage.image == nil && mukkaebieCommentTextField.text == "" {
            var count = 0
            for user in orderByUserTop3 {
                for mkb in (modelStore?.mkb)! {
                    if mkb["userId"] == user.key {
                        switch count {
                        case 0:
                            if mkb["mkbComment"] != nil {
                                mukkaebieCommentTextField.text = mkb["mkbComment"]
                            }
                            if mkb["imgUrl"] != nil {
                                firstMukkaebieImage.af_setImage(withURL: URL(string:mkb["imgUrl"]!)!, placeholderImage: #imageLiteral(resourceName: "woowatech"), filter: .none, progress: .none, progressQueue: DispatchQueue.global(), imageTransition: .noTransition, runImageTransitionIfCached: true, completion: nil)
                            }
                        case 1:
                            if mkb["imgUrl"] != nil {
                                secondMukkaebieImage.af_setImage(withURL: URL(string:mkb["imgUrl"]!)!, placeholderImage: #imageLiteral(resourceName: "woowatech"), filter: .none, progress: .none, progressQueue: DispatchQueue.global(), imageTransition: .noTransition, runImageTransitionIfCached: true, completion: nil)
                            }
                        case 3:
                            if mkb["imgUrl"] != nil {
                                thirdMukkaebieImage.af_setImage(withURL: URL(string:mkb["imgUrl"]!)!, placeholderImage: #imageLiteral(resourceName: "woowatech"), filter: .none, progress: .none, progressQueue: DispatchQueue.global(), imageTransition: .noTransition, runImageTransitionIfCached: true, completion: nil)
                            }
                        default:
                            break
                        }
                    }
                }
                count += 1
            }
        }
        
        if self.firstBottomConstraint.constant < 0 {
            UIView.animate(withDuration: 1.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.firstBottomConstraint.constant += self.firstAward.frame.height
                self.view.layoutSubviews()
                
            }, completion: nil)
            
            UIView.animate(withDuration: 1.5, delay: 2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.secondBottomConstraint.constant += self.secondAward.frame.height
                self.view.layoutSubviews()
                
            }, completion: nil)
            
            UIView.animate(withDuration: 1.5, delay: 3, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.thirdBottomConstraint.constant += self.thirdAward.frame.height
                self.view.layoutSubviews()
                
            }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        let mkbComment = sender.text
        postComment = mkbComment
        postComment(userId: "hjtech", mkbComment: mkbComment!)
    }
    
    @IBAction func firstProfileImagePicker(_ sender: Any) {
        self.view.window?.rootViewController?.present(imagePicker, animated: false, completion: nil)
    }
    
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
            postImgData = imgData
            postImgData(userId: "hjtech", imgData: imgData!)
        } else{
            print("something went wrong")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func postComment(userId: String, mkbComment: String){
        if postImgData == nil {
            if orderByUserTop3[0].key == userId {
                for mkb in (modelStore?.mkb)!.reversed() {
                    if mkb["userId"] == userId {
                        if mkb["imgUrl"] != nil {
                            networkMkb.postMkb(storeId: (modelStore?.id)!, userId: userId, mkbComment: mkbComment, imgUrl: mkb["imgUrl"]!)
                            return
                        } else {
                            networkMkb.postMkb(storeId: (modelStore?.id)!, userId: userId, mkbComment: mkbComment, imgUrl: "https://unstats.un.org/unsd/trade/events/2015/abudhabi/img/no-pic.png")
                            return
                        }
                    }
                }
                networkMkb.postMkb(storeId: (modelStore?.id)!, userId: userId, mkbComment: mkbComment, imgUrl: "https://unstats.un.org/unsd/trade/events/2015/abudhabi/img/no-pic.png")
            }
        } else {
            networkMkb.postMkb(storeId: (modelStore?.id)!, userId: userId, mkbComment: mkbComment, imgData: postImgData!)
        }
    }
    
    func postImgData(userId: String, imgData: Data) {
        if postComment == nil {
            if orderByUserTop3[0].key == userId {
                for mkb in (modelStore?.mkb)!.reversed() {
                    if mkb["userId"] == userId {
                        if mkb["mkbComment"] != nil && mkb["mkbComment"] != "" {
                            networkMkb.postMkb(storeId: (modelStore?.id)!, userId: userId, mkbComment: mkb["mkbComment"]!, imgData: imgData)
                            return
                        } else {
                            networkMkb.postMkb(storeId: (modelStore?.id)!, userId: userId, mkbComment: "먹깨비가 되었다!", imgData: imgData)
                            return
                        }
                    }
                }
                networkMkb.postMkb(storeId: (modelStore?.id)!, userId: userId, mkbComment: "먹깨비가 되었다!", imgData: imgData)
            }
        } else {
            networkMkb.postMkb(storeId: (modelStore?.id)!, userId: userId, mkbComment: postComment!, imgData: imgData)
        }
    }
}
