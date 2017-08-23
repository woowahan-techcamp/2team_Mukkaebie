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
    
    var modelStore : ModelStores?
    var orderByUserTop3 = [(key: String, value: Int)]()
    
    var postImage = UIImage()
    let imagePicker = UIImagePickerController()
    
    let networkImagePicker = NetworkImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame.size.height = 565
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.navigationBar.isTranslucent = false

//        staticHeight.constant -= gradeStackView.frame.height
        
        firstBottomConstraint.constant -= firstAward.frame.height
        secondBottomConstraint.constant -= secondAward.frame.height
        thirdBottomConstraint.constant -= thirdAward.frame.height

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstMukkaebieImage.image == nil && secondMukkaebieImage.image == nil && thirdMukkaebieImage.image == nil{
            var count = 0
            for user in orderByUserTop3 {
                for mkb in (modelStore?.mkb)! {
                    if mkb["userId"] == user.key {
                        switch count {
                        case 0:
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
            networkImagePicker.postImage(storeId: (modelStore?.id)!, userId: "hjtech", imgData: imgData!)
            
        } else{
            print("something went wrong")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
