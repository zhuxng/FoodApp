//
//  SectionModel.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/15.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import Foundation

class SectionModel {
    var title: String           // 分组的标题
    var folded = false          // 是否折叠
    var items: [Item] = []      // 分组中的所有项
    
    init(title: String) {
        self.title = title
    }
}
