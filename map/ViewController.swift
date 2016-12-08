//
//  ViewController.swift
//  map
//
//  Created by lushuishasha on 2016/10/17.
//  Copyright © 2016年 lushuishasha. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class ViewController: UIViewController{
    var hasBaiDuMap:Bool = false
    var hasGaoDeMap:Bool = false
    var hasGoogleDeMap:Bool = false
    var location : CLLocation!
    var locManager:CLLocationManager!
    var poiSearch: BMKPoiSearch!
    var currentPage: Int32 = 0
    
    lazy var mapView: BMKMapView = {
        let mapView = BMKMapView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height))
        return mapView
    }()
    
    lazy var cityField:UITextField = {
      let field = UITextField(frame: CGRect(x: 30, y: 40, width: 80, height: 30))
      field.placeholder = "请输入城市"
      field.setValue(UIFont.boldSystemFontOfSize(10), forKeyPath: "_placeholderLabel.font")
      field.borderStyle = .Bezel
      field.layer.borderWidth = 0.5
      return field
    }()
    
    lazy var keywordField:UITextField = {
        let field = UITextField(frame: CGRect(x: 150, y: 40, width: 80, height: 30))
        field.placeholder = "请输入关键字"
        field.setValue(UIFont.boldSystemFontOfSize(10), forKeyPath: "_placeholderLabel.font")
        field.layer.borderWidth = 0.5
        field.borderStyle = .Bezel
        return field
    }()
    
    lazy var startPoiBtn:UIButton = {
        let button = UIButton(frame:CGRect(x:250,y:40,width:50 ,height: 30))
        button.setTitle("开始", forState: .Normal)
        button.addTarget(self, action: #selector(jumpToSearchListViewController(_:)), forControlEvents: .TouchUpInside)
        button.setTitleColor(.blackColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(10)
        button.backgroundColor = .yellowColor()
        return button
    }()
    
    func jumpToSearchListViewController(sender:UIButton){
        //UIApplication.sharedApplication().showMapActionSheet("加油站")
        currentPage = 0
        sendPoiSearchResult()
    }
    
    func sendPoiSearchResult(){
        let citySearchOption = BMKCitySearchOption()
        citySearchOption.pageIndex = currentPage
        citySearchOption.pageCapacity = 10
        citySearchOption.city = self.cityField.text
        citySearchOption.keyword = self.keywordField.text
        let flag = poiSearch.poiSearchInCity(citySearchOption)
        if flag {
            print("城市内检索发送成功！")
        } else {
            print("城市内检索发送失败！")
        }
    }
    
    func setupLocation(){
        //如果设备没有开启定位服务
        if !CLLocationManager.locationServicesEnabled() {
            dispatch_async(dispatch_get_main_queue()) {
                NSLog("无法定位，因为您的设备没有启用定位服务，请到设置中启用")
            }
            return
        }
        self.locManager = CLLocationManager()
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest
        //变化距离  超过50米 重新定位
        self.locManager!.distanceFilter = 50
        //状态为，用户还没有做出选择，那么就弹窗让用户选择
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locManager.requestWhenInUseAuthorization()
        }
            
            //状态为，用户在设置-定位中选择了【永不】，就是不允许App使用定位服务
        else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied) {
            //需要把弹窗放在主线程才能强制显示
            dispatch_async(dispatch_get_main_queue()) {
                NSLog("无法定位，因为您的设备没有启用定位服务，请到设置中启用")
            }
            return
        }
        //设置定位获取成功或者失败后的代理，Class后面要加上CLLocationManagerDelegate协议
        locManager.delegate = self
        self.locManager?.startUpdatingLocation()
    }
    
    /* func setAlert() {
        let alertController = UIAlertController(title: nil, message: nil,preferredStyle: .ActionSheet)
        let baiduUrl = NSURL(string: "baidumap://")!
        let googleUrl = NSURL(string: "comgooglemaps://")!
        let gaodeUrl = NSURL(string: "iosamap://")!
        if (UIApplication.sharedApplication().canOpenURL(baiduUrl)) {
            let clickBaiDuMap = UIAlertAction(title: "百度地图", style: .Default, handler: {
                (action: UIAlertAction) -> Void in
                let urlString = "baidumap://map/place/search?query=加油站&origin=我的位置&radius=1000&region=深圳"
                let escapedAddress = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                let url = NSURL(string:escapedAddress!)
                UIApplication.sharedApplication().openURL(url!)
            })
            alertController.addAction(clickBaiDuMap)
        }
        
        if (UIApplication.sharedApplication().canOpenURL(googleUrl)) {
            let clickGaoDeMap = UIAlertAction(title: "谷歌地图", style: .Default, handler: {
                (action: UIAlertAction) -> Void in
                let urlString = "comgooglemaps://?q=Pizza&center=37.759748,-122.427135"
                let escapedAddress = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                let url = NSURL(string:escapedAddress!)
                UIApplication.sharedApplication().openURL(url!)
            })
            alertController.addAction(clickGaoDeMap)
        }
        
        if (UIApplication.sharedApplication().canOpenURL(gaodeUrl)) {
            let clickGaoDeMap = UIAlertAction(title: "高德地图", style: .Default, handler: {
                (action: UIAlertAction) -> Void in
                let urlString = "iosamap://arroundpoi?sourceApplication=applicationName&keywords=超市&lat=36.2&lon=116.1&dev=0"
                let escapedAddress = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                let url = NSURL(string:escapedAddress!)
                UIApplication.sharedApplication().openURL(url!)
            })
            alertController.addAction(clickGaoDeMap)
        }
        
        let systemAction = UIAlertAction(title: "苹果地图", style: .Default, handler:{
     (action: UIAlertAction) -> Void in
     let urlString = "http://maps.apple.com/?q=Mexican+Restaurant"
     let escapedAddress = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
     let url = NSURL(string:escapedAddress!)
     UIApplication.sharedApplication().openURL(url!)
        })
        alertController.addAction(systemAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {
            (action: UIAlertAction) -> Void in
        })
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }*/
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
        mapView.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        poiSearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
        mapView.delegate = nil // 不用时，置nil
        poiSearch.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(cityField)
        self.view.addSubview(keywordField)
        self.view.addSubview(startPoiBtn)
        self.view.addSubview(mapView)
        self.setupLocation()
        mapView.delegate = self
   
        cityField.text = "深圳"
        keywordField.text = "加油站"
        cityField.delegate = self
        keywordField.delegate = self
        
        poiSearch = BMKPoiSearch()
        poiSearch.delegate = self
        mapView.zoomLevel = 13
        mapView.isSelectedAnnotationViewFront = true
        mapView.userTrackingMode = BMKUserTrackingModeFollow
    }
    
    func addMySelfLocation(){
        let annotation = BMKPointAnnotation()
        annotation.coordinate = self.location.coordinate
        annotation.title = "我在这"
        annotation.subtitle = "你在哪儿呢"
        mapView.addAnnotation(annotation)
    }
}

extension ViewController: CLLocationManagerDelegate,BMKPoiSearchDelegate,UITextFieldDelegate,BMKMapViewDelegate{
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0{
            //  使用last 获取 最后一个最新的位置， 前面是上一次的位置信息
            let locationInfo:CLLocation = locations.last!
            self.location = locationInfo
            NSLog("经度：\(locationInfo.coordinate.longitude),纬度：\(locationInfo.coordinate.latitude)")
            self.addMySelfLocation()
        }
    }
    func locationManager(manager:CLLocationManager, didFailWithError error:NSError) {
        NSLog("定位发生异常:\(error)")
    }
    
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        //清除屏幕中所有的annotation
        mapView.removeAnnotations(mapView.annotations)
        var annotations = [BMKPointAnnotation]()
        if errorCode == BMK_SEARCH_NO_ERROR {
            for i in 0..<poiResult.poiInfoList.count{
                let poiInfo = poiResult.poiInfoList[i] as! BMKPoiInfo
                let annotation = BMKPointAnnotation()
                annotation.title = poiInfo.name
                annotation.coordinate = poiInfo.pt
                
                annotations.append(annotation)
            }
            mapView.addAnnotations(annotations)
            mapView.showAnnotations(annotations, animated: true)
        } else if errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD {
            print("检索词有歧义")
        } else {
            
        }
    }
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let annotationViewID = "annotationView"
        var  annotaionView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewID) as! BMKPinAnnotationView?
        if annotaionView == nil {
            annotaionView = BMKPinAnnotationView(annotation: annotation,reuseIdentifier: annotationViewID)
            annotaionView?.pinColor = UInt(BMKPinAnnotationColorPurple)
            annotaionView?.animatesDrop = true
            annotaionView?.draggable = false
            annotaionView?.canShowCallout = true
            
        }
        annotaionView?.annotation = annotation
        return annotaionView
    }
}


