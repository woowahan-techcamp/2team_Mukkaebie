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
    
    private(set) var password = String()
    private(set) var id = String()
    private(set) var name = String()
    private(set) var spent = Int()
    private(set) var createdDate = String()
    private(set) var baeminLevel = [level]()
    
    init() {}
    
    required init?(map: Map) {}
    
    init(password: String, id: String, name: String, spent: Int, createdDate: String, baeminLevel: [level]) {
        self.password = password
        self.id = id
        self.name = name
        self.spent = spent
        self.createdDate = createdDate
        self.baeminLevel = baeminLevel
    }
    
    func mapping(map: Map) {
        password <- map["pwd"]
        id <- map["userId"]
        name <- map["name"]
        spent <- map["spent"]
        createdDate <- map["createdDate"]
        baeminLevel <- map["baeminLevel"]
    }
}

class User {
    static let sharedInstance = User()
    var isUser = Bool() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "checkIsUser"), object: nil)
        }
    }
    var user = ModelUsers()
}
