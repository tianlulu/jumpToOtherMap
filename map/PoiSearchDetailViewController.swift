//
//  PoiSearchDetailViewController.swift
//  map
//
//  Created by lushuishasha on 2016/10/18.
//  Copyright © 2016年 lushuishasha. All rights reserved.
// 检索poi

import UIKit
class PoiSearchDetailViewController:UIViewController,BMKMapViewDelegate,BMKPoiSearchDelegate,UITextFieldDelegate{
    var poiSearch: BMKPoiSearch!
    
    lazy var mapView: BMKMapView = {
        let mapView = BMKMapView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height))
        return mapView
    }()
    
    override func viewDidLoad() {
       super.viewDidLoad()
       poiSearch = BMKPoiSearch()
    }
    
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
}
