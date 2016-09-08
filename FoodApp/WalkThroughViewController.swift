//
//  WalkThroughViewController.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/13.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIPageViewController, UIPageViewControllerDataSource {

    lazy var contentsArray: [IntroContent] = {
        // 创建一个装IntroContent对象的空数组
        var array: [IntroContent] = []
        
        var res = Foo(tableName: "Intro")
        
        // 通过循环向数组中添加3个IntroContent对象
        for i in 1 ... 3 {
            let content = IntroContent(heading: res.getString("H\(i)"), imageName: "foodpin-intro-\(i)", intro: res.getString("Intro\(i)"))
            array.append(content)
        }
        
        // 返回数组完成延迟加载(懒加载/惰性加载)
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let contentVC = createContentViewController(0) {
            self.setViewControllers([contentVC], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = (viewController as! ContentViewController).index
        return createContentViewController(currentIndex - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = (viewController as! ContentViewController).index
        return createContentViewController(currentIndex + 1)
    }
    
    func createContentViewController(index: Int) -> ContentViewController? {
        if index >= 0 && index <= contentsArray.count - 1 {
            if let contentVC = storyboard?.instantiateViewControllerWithIdentifier("Content") as? ContentViewController {
                let model = contentsArray[index]
                
                contentVC.heading = model.heading
                contentVC.intro = model.intro
                contentVC.imageName = model.imageName
                contentVC.index = index
                
                return contentVC
            }
        }
        return nil
    }

}
