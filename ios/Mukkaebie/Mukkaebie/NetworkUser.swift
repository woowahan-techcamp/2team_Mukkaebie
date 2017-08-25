
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


/*
static func getUser(callback: @escaping (_ result: Bool, _ modelUser: ModelUser) -> Void) {
    Alamofire.request("\(url)/api/v1/user/login").responseJSON { (response) in
        var modelUser = ModelUser()
        
        let res = JSON(data: response.data!)
        let result = res["result"].boolValue
        if let user = res["user"].dictionary {
            if let id = user["_id"]?.stringValue,
                let email = user["email"]?.stringValue,
                let isKakaoImage = user["isKakaoImage"]?.boolValue,
                let nickname = user["nickname"]?.stringValue,
                let bookmark = user["bookmark"]?.arrayValue.map({ $0.stringValue }) {
                var imageURL = String()
                if let userImageURL = user["imageURL"]?.stringValue {
                    imageURL = userImageURL
                }
                modelUser = ModelUser(id: id, isKakaoImage: isKakaoImage, email: email, nickname: nickname, bookmark: bookmark, profileImageURL: imageURL
                )
            }
        }
        callback(result, modelUser)
    }
}
*/
