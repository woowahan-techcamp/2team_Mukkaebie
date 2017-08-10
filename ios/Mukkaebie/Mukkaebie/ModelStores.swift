//
//  ModelUser.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation

class ModelStores {
    
    private var id = Int()
    private var name = String()
    private var createdDate = String()
//    private var order = []
    
    init() {}
    
    init(id: Int, name: String, createdDate: String) {
        self.id = id
        self.name = name
        self.createdDate = createdDate
    }
    
    func getStore() -> [String : Any] {
        var storeDic = [String : Any]()
        storeDic["id"] = id
        storeDic["name"] = name
        storeDic["createdDate"] = createdDate
        
        return storeDic
    }
    
}
