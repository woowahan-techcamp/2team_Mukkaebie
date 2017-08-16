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
    
    private let url = URLpath.getURL()
    
    
    func getOrderList(buyerId: Int) {
        Alamofire.request("\(url)orders/bystore/"+"\(buyerId)").responseJSON { (response) in
            if let response = response.result.value as? [[String:Any]] {
                var orderList = [ModelOrders]()
                for item in response {
                    var order = ModelOrders(JSON: item)
                    orderList.append(order!)
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getOrder"), object: nil, userInfo: ["orderList":orderList])
            }
        }
    }
    
    func postOrder(sellderId: Int, buyerId: String, price: Int, content: [String]) {
        let parameters = ["sellerId": sellderId, "buyerId": buyerId, "price": price, "content": content] as [String : Any]
        Alamofire.request("\(url)orders", method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
    }
    
    
}
