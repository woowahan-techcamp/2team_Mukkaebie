//
//  ModelUser.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation

class ModelStores {
    
    private var id = String()
    private var name = String()
    private var spent = Int()
    private var createdDate = String()
    
    init() {}
    
    init(id: String, name: String, spent: Int, createdDate: String, baeminLevel: [level]) {
        self.id = id
        self.name = name
        self.spent = spent
        self.createdDate = createdDate
        self.baeminLevel = baeminLevel
    }
    
    func getUser() -> [String : Any] {
        var userDic = [String : Any]()
        userDic["id"] = id
        userDic["name"] = name
        userDic["spent"] = spent
        userDic["createdDate"] = createdDate
        userDic["baeminLevel"] = baeminLevel
        
        return userDic
    }
    
}
