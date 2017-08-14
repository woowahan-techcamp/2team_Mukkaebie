//
//  ModelUser.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation
import ObjectMapper

class ModelStores: Mappable {
    private(set) var id = Int()
    private(set) var name = String()
    private(set) var createdDate = String()
    private(set) var orders = [ModelOrders]()
//    private var order = []
    
    init() {}
    
    required init?(map: Map) {}
    
    init(id: Int, name: String, createdDate: String) {
        self.id = id
        self.name = name
        self.createdDate = createdDate
    }
    
//    func getStore() -> [String : Any] {
//        var storeDic = [String : Any]()
//        storeDic["id"] = id
//        storeDic["name"] = name
//        storeDic["createdDate"] = createdDate
//        
//        return storeDic
//    }
    
    func mapping(map: Map) {
        id <- map["storeId"]
        name <- map["name"]
        createdDate <- map["createdDate"]
    }
}
