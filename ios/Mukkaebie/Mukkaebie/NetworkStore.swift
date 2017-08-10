//
//  NetworkUser.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation
import Alamofire


class NetworkStore {
    
    private static let url = URLpath.getURL()
    
    
    
    static func getStoreList() {
        Alamofire.request("\(url)stores").responseJSON { (response) in
            if let response = response.result.value as? [[String:Any]] {
                for item in response {
                    let store = ModelStores(JSON: item)
                    dump(store)
                }
            }
        }
        
    }
    
    
}
