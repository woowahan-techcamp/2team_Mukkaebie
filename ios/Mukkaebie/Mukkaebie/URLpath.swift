//
//  URLpath.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation

class URLpath {
    
    static func getURL() -> String {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let info = NSDictionary(contentsOfFile: filePath!)
        let url = info?["URL"] as! String

        return url
    }
    
}
