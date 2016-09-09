//
//  ViewController.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/2.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import UIKit

class ViewController: UITableViewController/*, UISearchResultsUpdating*/, UISearchBarDelegate {
    
    // 保存餐厅数据模型的数组
    var cafeArray = [Cafe]()
    var searchResults: [Cafe] = []
    
    var isSearching = false
    
    var res: Foo!
    
    // var searchController: UISearchController!
    @IBOutlet weak var addCafeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.redColor()
        
        res = Foo(tableName: "MyMain")
        
        // 代码重构(refactor) - 不改变代码功能(业务逻辑)的前提下调整代码结构
        // 1. 重复代码 - 抽取成独立的方法(函数)
        // 2. 长方法(函数) - 将一个方法(函数)分解成多个方法(函数)
        // 《重构: 改善既有代码的设计》 - Martin Fowler
        customizeTableView()
        
        customizeSearchBar()
        
        customizeNavigationItem()
        
        loadDataModel()
    }
    
    // private是表示私有的(外界无法访问)访问修饰符
    private func customizeTableView() {
        // 禁用点击状态栏回到表格视图的顶部
        self.tableView.scrollsToTop = false
        // 如果滚动视图所在的视图控制器有导航那么就要在下方垫64个点的空白区域
        // 否则表格视图自动滚动到最后一行时会看不到完整的最后一个单元格
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 113, 0)
    }
    
    private func customizeSearchBar() {
        let searchBar = UISearchBar(frame: CGRectMake(0, 0, 0, 40))
        searchBar.placeholder = res.getString("SearchBarPlaceHolder")
        searchBar.barTintColor = UIColor(red: 1.0, green: 178.0 / 255.0, blue: 181.0 / 255.0, alpha: 0.5)
        searchBar.tintColor = UIColor.whiteColor()
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        // searchBar.searchBarStyle = .Minimal
        tableView.tableHeaderView = searchBar
    }
    
    private func customizeNavigationItem() {
        // 设置当前视图控制器的导航项(每个视图控制器单独定制)
        // 定制返回按钮
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    private func loadDataModel() {
        for _ in 1 ... 10 {
            let cafe1 = Cafe()
            cafe1.name = "KFC"
            cafe1.type = "西式快餐"
            cafe1.tel = "1008611"
            cafe1.photo = UIImage(named: "upstate")
            cafe1.location = "成都市一环路西二段17号四川省旅游学院"
            
            cafeArray.append(cafe1)
            
            let cafe2 = Cafe()
            cafe2.name = "必胜客"
            cafe2.type = "西式快餐"
            cafe2.tel = "400-820-8820"
            cafe2.photo = UIImage(named: "confessional")
            cafe2.location = "成都市二环路北一段111号西南交通大学"
            
            cafeArray.append(cafe2)
            
            let cafe3 = Cafe()
            cafe3.name = "满记甜品"
            cafe3.type = "甜品"
            cafe3.tel = "028-88661789"
            cafe3.photo = UIImage(named: "haighschocolate")
            cafe3.location = "成都市青羊区中同仁路8号"
            
            cafeArray.append(cafe3)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置滑动时隐藏导航栏
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if !userDefaults.boolForKey("hasWalked") {
            if let walkVC = storyboard?.instantiateViewControllerWithIdentifier("Walk") as? WalkThroughViewController {
                self.presentViewController(walkVC, animated: true, completion: nil)
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            searchBar.resignFirstResponder()
            searchResults = cafeArray.filter({ (tempCafe) -> Bool in
                return tempCafe.name.rangeOfString(keyword, options: .CaseInsensitiveSearch) != nil
            })
            isSearching = true
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
        self.addCafeButton.enabled = true
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.addCafeButton.enabled = false
        return true
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }

    // 告诉表格视图有多少个单元格
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchResults.count : cafeArray.count
    }
    
    // 通过复用机制获得单元格并绑定数据模型
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 通过复用机制获取单元格
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BasicInfoTableViewCell
        
        // 从数组中取出和单元格对应的数据模型
        let model = isSearching ? searchResults[indexPath.row] : cafeArray[indexPath.row]
        // 将模型和视图进行绑定
        cell.nameLabel.text = model.name
        cell.typeLabel.text = model.type
        cell.telLabel.text = model.tel
        cell.photoImageView.image = model.photo
        
        return cell
    }
    
    // 是否可以编辑表格视图的单元格
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !isSearching
    }
    
    // 定制单元格左滑时的功能按钮
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delAction = UITableViewRowAction(style: .Default, title: res.getString("Delete")) { (rowAction, indexPath) -> Void in
            // 先从数组中移除数据模型
            self.cafeArray.removeAtIndex(indexPath.row)
            // 再从表格视图中移除单元格
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
        let topAction = UITableViewRowAction(style: .Default, title: res.getString("Top")) { (rowAction, indexPath) -> Void in
            // 从数组中获得需要置顶的模型对象
            let model = self.cafeArray[indexPath.row]
            // 将模型从数组中原来的位置删除
            self.cafeArray.removeAtIndex(indexPath.row)
            // 将模型插入数组中作为第一个元素
            self.cafeArray.insert(model, atIndex: 0)
            // 刷新表格视图
            self.tableView.reloadData()
        }
        topAction.backgroundColor = UIColor(red: 253.0 / 255.0, green: 178.0 / 255.0, blue: 32.0 / 255.0, alpha: 1)
        let shareAction = UITableViewRowAction(style: .Default, title: res.getString("Share")) { (rowAction, indexPath) -> Void in
            let model = self.cafeArray[indexPath.row]
            // 创建UIActivityViewController使用系统自带的分享功能
            let activityController = UIActivityViewController(activityItems: ["\(self.res.getString("Name")): \(model.name); \(self.res.getString("Tel")): \(model.tel)", model.photo!], applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)
        }
        shareAction.backgroundColor = UIColor(red: 33.0 / 255.0, green: 193.0 / 255.0, blue: 251.0 / 255.0, alpha: 1)
        
        return [delAction, topAction, shareAction]
    }
    
    // 通过segue从当前视图控制器向下一个视图控制器传递数据
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 导航到新的视图控制器时隐藏底部分栏条
        segue.destinationViewController.hidesBottomBarWhenPushed = true
        
        if segue.identifier == "toDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let detailVC = segue.destinationViewController as! DetailViewController
                // 从搜索结果点击单元格进入详情界面时要从searchResults中取模型
                detailVC.model = isSearching ? searchResults[indexPath.row] : cafeArray[indexPath.row]
            }
        }
        else if segue.identifier == "toAdd" {
            let addCafeVC = segue.destinationViewController as! AddCafeViewController
            addCafeVC.addCafeHandler = { (model) -> Void in
                self.cafeArray.append(model)
                let indexPath = NSIndexPath(forRow: self.cafeArray.count - 1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
                // 表格视图自动滚动到最后一行的位置
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
            }
        }
    }

}

