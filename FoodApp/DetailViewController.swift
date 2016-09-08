//
//  DetailViewController.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/2.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingButton: UIButton!
    
    // 定义一个变量接收从表格视图控制器传过来的模型对象
    var model: Cafe!
    
    var res: Foo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        res = Foo(tableName: "MyMain")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        photoImageView.image = model.photo
        
        myTableView.estimatedRowHeight = 60.0
        // 单元格行高自适应(前提: 需要自动布局)
        myTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置滑动时不隐藏导航栏
        self.navigationController?.hidesBarsOnSwipe = false
        // 如果导航栏被隐藏了就强制显示
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        if model.rating != "" {
            ratingButton.setImage(UIImage(named: model.rating), forState: .Normal)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ItemTableViewCell
        
        if indexPath.row == 0 {
            cell.keyLabel.text = res.getString("Name")
            cell.valueLabel.text = model.name
        }
        else if indexPath.row == 1 {
            cell.keyLabel.text = res.getString("Type")
            cell.valueLabel.text = model.type
        }
        else if indexPath.row == 2 {
            cell.keyLabel.text = res.getString("Location")
            cell.valueLabel.text = model.location
        }
        else if indexPath.row == 3 {
            cell.keyLabel.text = res.getString("Tel")
            cell.valueLabel.text = model.tel
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toRating" {
            let ratingVC = segue.destinationViewController as! RatingViewController
            ratingVC.model = model
        }
        else if segue.identifier == "toMap" {
            let mapVC = segue.destinationViewController as! MapViewController
            mapVC.model = model
        }
    }
}
