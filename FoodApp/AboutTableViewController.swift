//
//  AboutTableViewController.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/15.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    lazy var dataModel: [SectionModel] = {
        var array:[SectionModel] = []
        
        // 设置资源文件的名字
        let res = Foo(tableName: "MyAbout")
        // 通过封装好的Foo类从资源文件中读取字符串
        let model1 = SectionModel(title: res.getString("Title1"))
        model1.items.append(Item(name: res.getString("Rating"), urlStr: ""))
        model1.items.append(Item(name: res.getString("Blame"), urlStr: ""))
        
        let model2 = SectionModel(title: res.getString("Title2"))
        model2.items.append(Item(name: res.getString("Home"), urlStr: "http://blog.csdn.net/jackfrued"))
        model2.items.append(Item(name: res.getString("Blog"), urlStr: "http://t.qq.com/jackfrued"))
        model2.items.append(Item(name: res.getString("Company"), urlStr: "http://www.mobiletrain.org"))
        
        array.append(model1)
        array.append(model2)
        
        return array
    }()
    
    let imageNames = ["cafedeadend", "homei", "posatelier", "teakha", "cafedeadend"]
    var screenWidth: CGFloat!
    
    var timer: NSTimer!
    var currentIndex = 0

    // MARK: - 视图控制器生命周期相关方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = tableView.frame.size.width
        
        // hack
        tableView.tableFooterView = UIView()
        
        customizeScrollView()
        
        customizePageControl()
        
        timer = NSTimer(timeInterval: 2.0, target: self, selector: Selector("changeImage:"), userInfo: nil, repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    // MARK: - 时钟事件回调方法
    func changeImage(sender: NSTimer) {
        currentIndex += 1
        currentIndex %= imageNames.count
        myScrollView.setContentOffset(CGPointMake(CGFloat(currentIndex) * screenWidth, 0), animated: true)
        if currentIndex == imageNames.count - 1 {
            NSOperationQueue().addOperation(NSBlockOperation(block: { () -> Void in
                usleep(500000)
                self.myScrollView.setContentOffset(CGPointMake(0, 0), animated: false)
            }))
            currentIndex = 0
        }
    }
    
    // MARK: - 定制用户界面的方法
    func customizeScrollView() {
        for i in 0 ..< imageNames.count {
            let imageView = UIImageView(frame: CGRectMake(CGFloat(i) * screenWidth, 0, screenWidth, 250))
            imageView.image = UIImage(named: imageNames[i])
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            myScrollView.addSubview(imageView)
        }
        myScrollView.pagingEnabled = true
        myScrollView.contentSize = CGSizeMake(CGFloat(imageNames.count) * screenWidth, 250)
    }
    
    func customizePageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = imageNames.count - 1
    }
    
    // MARK: - 滚动视图委托相关方法
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == myScrollView {
            pageControl.currentPage = Int(scrollView.contentOffset.x / screenWidth) % (imageNames.count - 1)
        }
    }

    // MARK: - 表格视图数据源协议相关方法
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataModel.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel[section].folded ? 0 : dataModel[section].items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = dataModel[indexPath.section].items[indexPath.row].name

        return cell
    }


    // MARK: - 表格视图委托协议相关方法
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if let webVC = storyboard?.instantiateViewControllerWithIdentifier("Web") as? WebViewController {
                webVC.hidesBottomBarWhenPushed = true
                webVC.urlStr = dataModel[indexPath.section].items[indexPath.row].urlStr
                self.navigationController?.pushViewController(webVC, animated: true)
            }
        }
        else if indexPath.section == 0 && indexPath.row == 0 {
            if let url = NSURL(string: "https://itunes.apple.com/us/app/mei-shi-can-ting/id1124480728?l=zh&ls=1&mt=8") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    // 获取表格视图分区头部高度的方法
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 折叠时高度是40 展开时高度是30
        return dataModel[section].folded ? 40.0 : 30.0
    }
    
    // 定制表格视图分区头部视图的方法
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 创建一个高度为40的UIView作为背景
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        view.backgroundColor = UIColor.whiteColor()
        // 创建一个高度为30的UIButton显示分组的标题并支持点击折叠或展开
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, 0, tableView.frame.size.width, 30)
        button.tag = 200 + section
        button.backgroundColor = UIColor(red: 110.0 / 255.0, green: 150.0 / 255.0, blue: 240 / 255.0, alpha: 1)
        button.setTitle(dataModel[section].title, forState: .Normal)
        button.addTarget(self, action: Selector("foldSection:"), forControlEvents: .TouchUpInside)
        // 将按钮添加到背景视图中
        view.addSubview(button)
        return view
    }
    
    // 点击表格视图分区头部按钮时要执行的方法
    func foldSection(sender: UIButton) {
        let model = dataModel[sender.tag - 200]
        model.folded = !model.folded
        tableView.reloadData()
    }

    
    // MARK: - Segue导航方法
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
