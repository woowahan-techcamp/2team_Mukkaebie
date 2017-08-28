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
    private(set) var imgURL = String()
    private(set) var category = String()
    private(set) var address = String()
    private(set) var ratingValue = Float()
    private(set) var ratingCount = Int()
    private(set) var minPrice = String()
    private(set) var openHour = String()
    private(set) var telephone = String()
    private(set) var storeDesc = String()
    private(set) var review = [String()]
    private(set) var menu = [[String:[String:String]]]()
    private(set) var createdDate = String()
    private(set) var mkb = [[String:String]]()
    var orderByMenu = [String:Int]()
    var priceByMenu = [String:Int]()
    var orderByUser = [String:Int]()
    
    init() {}
    
    required init?(map: Map) {}
    
    init(id: Int, name: String, createdDate: String) {
        self.id = id
        self.name = name
        self.createdDate = createdDate
    }
    
    func mapping(map: Map) {
        id <- map["storeId"]
        name <- map["storeName"]
        imgURL <- map["storeImg"]
        category <- map["category"]
        address <- map["address"]
        ratingValue <- map["ratingValue"]
        ratingCount <- map["ratingCount"]
        minPrice <- map["minPrice"]
        openHour <- map["openHour"]
        telephone <- map["telephone"]
        storeDesc <- map["storeDesc"]
        review <- map["review"]
        menu <- map["menu"]
        mkb <- map["mkb"]
        createdDate <- map["createdDate"]
    }
    
    func initOrderByMenu() {
        orderByMenu = [String:Int]()
        if (Store.sharedInstance.specificStore?.menu.count)! > 0 {
            let menu = (Store.sharedInstance.specificStore?.menu)![0]
            for (_, submenu) in menu {
                for (name, _) in submenu {
                    orderByMenu[name] = 0
                }
            }
        }
        
        for order in Order.sharedInstance.specificStoreOrder {
            for content in order.content {
                Store.sharedInstance.specificStore.orderByMenu[content]! += 1
            }
        }
    }
    
    func initPriceByMenu() {
        priceByMenu = [String:Int]()
        if (Store.sharedInstance.specificStore?.menu.count)! > 0 {
            let menu = (Store.sharedInstance.specificStore?.menu)![0]
            for (_, submenu) in menu {
                for (name, price) in submenu {
                    priceByMenu[name] = Int(price.substring(to: price.index(before: price.endIndex)).replacingOccurrences(of: ",", with: ""))
                }
            }
        }
    }
    
    func initOrderByUser() {
        orderByUser = [String:Int]()
        for order in Order.sharedInstance.specificStoreOrder {
            if Store.sharedInstance.specificStore.orderByUser[order.buyerId] == nil {
                Store.sharedInstance.specificStore.orderByUser[order.buyerId] = 1
            } else {
                Store.sharedInstance.specificStore.orderByUser[order.buyerId]! += 1
            }
        }
    }
}

class Store {
    static let sharedInstance = Store()
    
    var allStores : [ModelStores]!
    var categoryStoreList : [ModelStores]!
    var specificStore : ModelStores! {
        didSet {
            self.specificStore.initPriceByMenu()
        }
    }
}
