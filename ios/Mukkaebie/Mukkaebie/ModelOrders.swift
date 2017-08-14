//
//  ModelOrders.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 11..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation
import ObjectMapper

class ModelOrders: Mappable {
    
    private var buyerId = String()
    private var sellerId = Int()
    private var price = Int()
    private var content = [String]()
    private var createdDate = String()
    
    init() {}
    
    required init?(map: Map) {}
    
    init(menu: [[String:Any?]], buyerId: String, sellerId: Int, price: Int, content: [String], createdDate: String) {
        self.buyerId = buyerId
        self.sellerId = sellerId
        self.price = price
        self.content = content
        self.createdDate = createdDate
    }
    
//    func getOrder() -> [String : Any] {
//        var userDic = [String : Any]()
//        userDic["buyerId"] = buyerId
//        userDic["sellerId"] = sellerId
//        userDic["price"] = price
//        userDic["content"] = content
//        userDic["createdDate"] = createdDate
//        
//        return userDic
//    }
    
    func mapping(map: Map) {
        buyerId <- map["buyerId"]
        sellerId <- map["sellerId"]
        price <- map["price"]
        content <- map["content"]
        createdDate <- map["createdDate"]
    }
    
}
