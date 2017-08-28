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
    
    static func getOrderList(sellerId: Int, callback: @escaping (_ storeList: [ModelOrders]) -> Void) {
        Alamofire.request("\(url)orders/bystore/"+"\(sellerId)").responseJSON { (response) in
            if let response = response.result.value as? [[String:Any]] {
                var orderList = [ModelOrders]()
                for item in response {
                    let order = ModelOrders(JSON: item)
                    orderList.append(order!)
                }
                callback(orderList)
            }
        }
    }
    
    func postOrder(sellderId: Int, buyerId: String, price: Int, content: [String]) {
        let parameters = ["sellerId": sellderId, "buyerId": buyerId, "price": price, "content": content] as [String : Any]
        Alamofire.request("\(NetworkOrder.url)orders", method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postOrder"), object: nil, userInfo: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
}
