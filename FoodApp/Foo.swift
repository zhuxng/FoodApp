//
//  LocalizationUtil.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/16.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import Foundation

// 读取资源文件做国际化/本地化的工具类
class Foo {
    
    // 国际化的字符串资源文件的名字
    var tableName: String
    
    init(tableName: String) {
        self.tableName = tableName
    }
    
    // 根据key读取对应的字符串资源
    func getString(key: String) -> String {
        return NSLocalizedString(key, tableName: tableName, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}