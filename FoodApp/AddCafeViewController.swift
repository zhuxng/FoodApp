//
//  AddCafeViewController.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/3.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import UIKit
import CoreLocation

class AddCafeViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var telField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var locLabel: UILabel!
    
    var addCafeHandler: ((Cafe) -> Void)!
    
    var currentName = ""
    var currentType = ""
    var currentTel = ""
    var currentLoc = ""
    var currentPhoto: UIImage?
    
    var locationManager = CLLocationManager()
    
    var res: Foo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        res = Foo(tableName: "MyMain")
    
        // 设置定位精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 设置距离过滤器
        locationManager.distanceFilter = 50.0
        // 设置定位管理器的委托
        locationManager.delegate = self
        
        updateLocation()
    }
    
    // 定位服务授权状态发生变化时就会执行该方法
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 如果授权成功了就开启显示用户位置并开始更新位置信息
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        if locations.count > 0 {
            geoCoder.reverseGeocodeLocation(locations[0]) { (placeMarks, error) -> Void in
                if error == nil {
                    if let array = placeMarks {
                        self.currentLoc = array[0].name!
                        self.locLabel.text = self.currentLoc
                        manager.stopUpdatingLocation()
                    }
                }
                else {
                    print(error!)
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func cancelAddCafe(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveCafe(sender: AnyObject) {
        if currentName != "" && currentType != "" && currentTel != "" && currentPhoto != nil && currentLoc != "" {
            // 如果餐厅信息是完整的就创建餐厅对象
            let model = Cafe()
            // 给餐厅对象指定对应的属性值
            model.name = currentName
            model.tel = currentTel
            model.photo = currentPhoto
            model.type = currentType
            model.location = currentLoc
            // 通过addRowHandler变量调用函数实现反向传值
            self.addCafeHandler(model)
            // 返回上一个视图控制器(导航视图控制器出栈)
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            let alertController = UIAlertController(title: res.getString("AlertTitle1"), message: res.getString("AlertMessage1"), preferredStyle: .Alert)
            let okAction = UIAlertAction(title: res.getString("OKButton"), style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func refreshLocation(sender: AnyObject) {
        updateLocation()
    }
    
    @IBAction func editLocation(sender: UIButton) {
        let locationStr = locLabel.text
        let alertController = UIAlertController(title: res.getString("AlertTitle2"), message: "", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.text = locationStr
            textField.clearButtonMode = .Always
        }
        let okAction = UIAlertAction(title: res.getString("OKButton"), style: .Default) { (action) -> Void in
            if let textFields = alertController.textFields {
                self.currentLoc = textFields[0].text!
                self.locLabel.text = self.currentLoc
            }
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func updateLocation() {
        // 获取定位服务的授权状态
        let status = CLLocationManager.authorizationStatus()
        
        if status == .NotDetermined {
            // 通过代码请求授权定位服务
            locationManager.requestWhenInUseAuthorization()
        }
        else if status == .Denied {
            // 提示用户重新授权定位服务
            let alertController = UIAlertController(title: res.getString("AlertTitle1"), message: res.getString("AlertMessage2"), preferredStyle: .Alert)
            let settingAction = UIAlertAction(title: res.getString("SettingButton"), style: .Default, handler: { (action) -> Void in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            let cancelAction = UIAlertAction(title: res.getString("CancelButton"), style: .Cancel, handler: nil)
            alertController.addAction(settingAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let ipc = UIImagePickerController()
            ipc.sourceType = UIImagePickerController.isSourceTypeAvailable(.Camera) ? .Camera : .PhotoLibrary
            ipc.allowsEditing = true
            ipc.delegate = self
            self.presentViewController(ipc, animated: true, completion: nil)
        }
        // 单元格不会处于选中状态
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // 触摸除文本框外的任意位置隐藏输入键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if nameField.isFirstResponder() {
            nameField.resignFirstResponder()
        }
        else if telField.isFirstResponder() {
            telField.resignFirstResponder()
        }
        else if typeField.isFirstResponder() {
            typeField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == nameField {
            currentName = textField.text!
        }
        else if textField == telField {
            currentTel = textField.text!
        }
        else if textField == typeField {
            currentType = textField.text!
        }
    }
   
    // 选取照片后要执行的方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        currentPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        photoImageView.image = currentPhoto
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 取消选择照片后要执行的方法
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
