//
//  LoginViewController.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 25..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var successView: UIView!
    
    @IBOutlet weak var successLabel: UILabel!
    
    @IBOutlet weak var alartMessageLabel: UILabel!
    var modelUser = ModelUsers()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idView.layer.borderWidth = 1
        idView.layer.borderColor = UIColor(hexString: "cccccc").cgColor
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor(hexString: "cccccc").cgColor
        
        alartMessageLabel.isHidden = true
        
        successView.isHidden = true

        // Do any additional setup after loading the view.
        
         NotificationCenter.default.addObserver(self, selector: #selector(getUsers(_:)), name: NSNotification.Name(rawValue: "getUser"), object: nil)
        
    }
    
    func getUsers(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let userModel = userInfo["User"] as? ModelUsers else { return }
        self.modelUser = userModel
        checkedUser()

        print("========",modelUser.id)
        
    }
    
    func checkedUser() {
        if modelUser.id == idTextField.text && modelUser.password == passwordTextField.text {
            successView.isHidden = false
            successLabel.text = "\(idTextField.text!)님 환영합니다!"
        }
    }

    
    @IBAction func touchedLogin(_ sender: Any) {
        NetworkUser.getUserList(userID: idTextField.text!)
        
    }
    
    @IBAction func touchedLogOut(_ sender: Any) {
        successView.isHidden = true
        idTextField.text = ""
        passwordTextField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
