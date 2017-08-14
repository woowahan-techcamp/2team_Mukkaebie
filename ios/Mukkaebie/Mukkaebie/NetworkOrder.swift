//
//  NetworkOrder.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 11..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation
import Alamofire

class NetworkOrder {
    
    private static let url = URLpath.getURL()
    
    
    static func getOrderList(buyerId: Int) {
        Alamofire.request("\(url)orders/bystore/"+"\(buyerId)").responseJSON { (response) in
            if let response = response.result.value as? [[String:Any]] {
                var orderList = [ModelOrders]()
                for item in response {
                    var order = ModelOrders(JSON: item)
                    orderList.append(order!)
                    dump(order)
                }
            }
        }
    }
    
    
}


//func getStoreList() {
//    Alamofire.request("\(url)stores").responseJSON { (response) in
//        if let response = response.result.value as? [[String:Any]] {
//            var storeList = [ModelStores]()
//            for item in response {
//                var store = ModelStores(JSON: item)
//                storeList.append(store!)
//                
//            }
//            
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getStore"), object: nil, userInfo: ["storeList":storeList])
//        }
//    }
//}
//    
