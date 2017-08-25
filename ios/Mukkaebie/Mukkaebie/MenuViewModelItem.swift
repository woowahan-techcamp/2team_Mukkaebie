//
//  MenuViewModelItem.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation

class MenuViewModelItem  {
    var sectionTitle: String
    var rowCount : Int
    var isCollapsible = true
    var isCollapsed: Bool
    
    init(sectionTitle: String, rowCount: Int, isCollapsed: Bool ) {
        self.sectionTitle = sectionTitle
        self.rowCount = rowCount
        self.isCollapsed = isCollapsed
    }
}

