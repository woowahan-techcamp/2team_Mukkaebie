//
//  StaticFunction.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 27..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation
import UIKit

let allStores = Store.sharedInstance.allStores
var specificStore = Store.sharedInstance.specificStore

let foodCategoryArray = ["치킨","중국집","피자","한식","족발,보쌈","야식","찜,탕","돈까스,회,일식","도시락","패스트푸드"]
let foodCategoryArrayForURL = ["치킨","중국집","피자","한식","족발","야식","찜탕","일식","도시락","패스트푸드"]

let indicatorView = Indicator()
