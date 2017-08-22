//
//  MukkaebieRankViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import Alamofire

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
    
    var orderByUserTop3 = [(key: String, value: Int)]()
    
    var postImage = UIImage()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.navigationBar.isTranslucent = false
        
//        firstAward.frame = CGRect(x: firstAward.frame.minX, y: self.view.frame.maxY, width: firstAward.frame.width, height: firstAward.frame.height)
//        secondAward.frame = CGRect(x: secondAward.frame.minX, y: self.view.frame.maxY, width: secondAward.frame.width, height: secondAward.frame.height)
//        thirdAward.frame = CGRect(x: thirdAward.frame.minX, y: self.view.frame.maxY, width: thirdAward.frame.width, height: thirdAward.frame.height)

//        staticHeight.constant -= gradeStackView.frame.height
        
//        firstBottomConstraint.constant -= firstAward.frame.height
//        secondBottomConstraint.constant -= secondAward.frame.height
//        thirdBottomConstraint.constant -= thirdAward.frame.height

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if self.firstBottomConstraint.constant < 0 {
        
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//            self.staticHeight.constant += self.gradeStackView.frame.height
//            self.view.layoutSubviews()
//
//        }, completion: nil)
//
//        
//            UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
//
//                self.staticHeight.constant += self.gradeStackView.frame.height
//                self.view.layoutIfNeeded()
//            }, completion: nil)
//        
////
//            UIView.animate(withDuration: 2, delay: 0.5, options: .curveEaseInOut, animations: {
//                self.secondBottomConstraint.constant += self.secondAward.frame.height
//                self.view.layoutIfNeeded()
//            }, completion: nil)
//        
//        
//            UIView.animate(withDuration: 1, delay: 2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
//                self.thirdBottomConstraint.constant += self.thirdAward.frame.height
//                self.view.layoutIfNeeded()
//            }, completion: nil)

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
            firstMukkaebieImage.image = image
        } else{
            print("something went wrong")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
