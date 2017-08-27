
//
//  NetworkUser.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 11..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation
import Alamofire

class NetworkUser {
    
    private static let url = URLpath.getURL()
    
    static func getUserList(userID : String) {
        Alamofire.request("\(url)users/cf/"+"\(userID)").responseJSON { (response) in
            if let response = response.result.value as? [[String:Any]] {
                var userDic = ModelUsers()
                for item in response {
                    userDic = ModelUsers(JSON: item)!
                    
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getUser"), object: nil, userInfo: ["User":userDic])
            }
        }
    }
    
}
