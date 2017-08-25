//
//  ModelUser.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation
import ObjectMapper

enum level {
    case white
    case purple
    case red
    case black
}

class ModelUsers: Mappable {
    
    private var id = String()
    private var name = String()
    private var spent = Int()
    private var createdDate = String()
    private var baeminLevel = [level]()
    
    init() {}
    
    required init?(map: Map) {}
    
    init(id: String, name: String, spent: Int, createdDate: String, baeminLevel: [level]) {
        self.id = id
        self.name = name
        self.spent = spent
        self.createdDate = createdDate
        self.baeminLevel = baeminLevel
    }
    
    func mapping(map: Map) {
        id <- map["userId"]
        name <- map["name"]
        spent <- map["spent"]
        createdDate <- map["createdDate"]
        baeminLevel <- map["baeminLevel"]
    }
    
}
