//
//  Item.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/15.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import Foundation

class Item {
    var name: String        // 名称
    var urlStr: String      // URL
    
    init(name: String, urlStr: String) {
        self.name = name
        self.urlStr = urlStr
    }
}