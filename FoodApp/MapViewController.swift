//
//  MapViewController.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/7.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    
    var model: Cafe!
    var locationManager = CLLocationManager()
    
    var res: Foo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        res = Foo(tableName: "MyMain")
        
        // 设置定位精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 设置距离过滤器
        locationManager.distanceFilter = 10.0
        // 设置定位管理器的委托
        locationManager.delegate = self
        
        // 获取定位服务的授权状态
        let status = CLLocationManager.authorizationStatus()
        
        if status == .NotDetermined {
            // 通过代码请求授权定位服务
            locationManager.requestWhenInUseAuthorization()
        }
        else if status == .Denied {
            // 提示用户重新授权定位服务
            let alertController = UIAlertController(title: res.getString("Hint"), message: res.getString("AlertMessage2"), preferredStyle: .Alert)
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
        
        // 比例尺
        // myMapView.showsScale = true
        // 罗盘
        // myMapView.showsCompass = true
        // 交通状况
        // myMapView.showsTraffic = true
        
        // 创建地理信息编码器对象
        let geoCoder = CLGeocoder()
        // 地理信息正向编码(地名 ---> 经纬度坐标)
        geoCoder.geocodeAddressString(model.location) {
            // 第一个参数是一个数组里面装的是CLPlacemark对象
            // 第二个参数代表地理信息编码时是否出错 没有出错就是nil
            (pMarks, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                if let array = pMarks {
                    // 从数组中取出第一个CLPlacemark对象
                    let mark = array[0]
                    // 通过CLPlacemark对象获得经纬度坐标
                    if let coordinate = mark.location?.coordinate {
                        // 添加点标注(大头针)数据模型
                        let pinModel = MKPointAnnotation()
                        pinModel.title = self.model.name
                        pinModel.subtitle = self.model.type
                        pinModel.coordinate = coordinate
                        
                        // 在地图上添加点标注
                        self.myMapView.addAnnotation(pinModel)
                        // 显示所有的点标注
                        self.myMapView.showAnnotations([pinModel], animated: true)
                        // 选中指定的点标注
                        self.myMapView.selectAnnotation(pinModel, animated: true)
                        
                        // 指定经纬度的跨度为0.01度
                        let span = MKCoordinateSpanMake(0.01, 0.01)
                        // 构造地图显示区域(第一个参数是中心点, 第二个参数是跨度)
                        let region = MKCoordinateRegionMake(coordinate, span)
                        self.myMapView.setRegion(region, animated: false)
                        
                        // 创建两个地图项(一个是当前位置, 一个是餐厅位置)
                        let sourceItem = MKMapItem.mapItemForCurrentLocation()
                        let mapMark = MKPlacemark(placemark: mark)
                        let destItem = MKMapItem(placemark: mapMark)
                        
                        // 创建一个获得路线的请求
                        let request = MKDirectionsRequest()
                        request.source = sourceItem
                        request.destination = destItem
                        // 通过MKDirections对象向服务器发送请求并处理响应
                        MKDirections(request: request).calculateDirectionsWithCompletionHandler({ (response, error) -> Void in
                            if error != nil {
                                print(error)
                            }
                            else {
                                // 从响应对象中获取路径数组
                                if let routes = response?.routes {
                                    for route in routes {
                                        // 将路径的折线模型添加到地图视图上
                                        self.myMapView.addOverlay(route.polyline)
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }

    }
    
    // 定位服务授权状态发生变化时就会执行该方法
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 如果授权成功了就开启显示用户位置并开始更新位置信息
        if status == .AuthorizedWhenInUse {
            self.myMapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    // 返回地图覆盖物(折线)渲染器的方法(通过渲染器才能将折线数据绘制成图形)
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        // 线条粗细
        renderer.lineWidth = 6
        // 线条颜色
        renderer.strokeColor = UIColor.blueColor()
        // 线条连接点形状
        renderer.lineJoin = .Round
        // 线条端点形状
        renderer.lineCap = .Round
        
        return renderer
    }
    
    // 定制点标注视图的方法
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 如果是用户当前位置的点标注不需要定制视图
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // 给大头针数据模型定制视图
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("Pin") as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            pinView?.canShowCallout = true
            pinView?.animatesDrop = true
        }
        
        // 定制大头针气泡左侧附加视图
        let imageView = UIImageView(frame: CGRectMake(5, 5, 42, 42))
        imageView.image = model.photo
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        pinView?.leftCalloutAccessoryView = imageView
        
        return pinView
    }

    @IBAction func changeMapType(sender: UISegmentedControl) {
        let types = [MKMapType.Standard, .Satellite, .Hybrid]
        myMapView.mapType = types[sender.selectedSegmentIndex]
    }
    
}
