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
                for item in response {
                    let order = ModelOrders(JSON: item)
                    //dump(order)
                }
            }
        }
    }
    
    
}
