//
//  WebViewController.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/15.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var urlStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 不要自动调整滚动视图的视点位置
        self.automaticallyAdjustsScrollViewInsets = false
        
        webView.scalesPageToFit = true
        
        // 通过代码指定UIWebView中加载的页面
        if let url = NSURL(string: urlStr) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }

}
