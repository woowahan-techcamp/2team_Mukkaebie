
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
    
    static func getUserList() {
        Alamofire.request("\(url)users").responseJSON { (response) in
            if let response = response.result.value as? [[String:Any]] {
                for item in response {
                    let user = ModelUsers(JSON: item)
                    //dump(user)
                }
            }
        }
    }
    
}
