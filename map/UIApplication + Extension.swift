//
//  PoiSearchResult.swift
//  WuLiuNoProblem
//
//  Created by lushuishasha on 2016/10/19.
//  Copyright © 2016年 FavourFree. All rights reserved.
// 应用内跳转至地图的POI搜索(不需要集成SDK)

import UIKit
public extension UIApplication {
    func openUrl(urlStr:String) {
        let escapedAddress = urlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string:escapedAddress!)
        UIApplication.sharedApplication().openURL(url!)
    }
    func openBaiDuMap(keyword:String) {
    let baiduUrlString = String(format:"baidumap://map/place/search?query=%@&origin=我的位置&radius=1000&region=深圳",keyword)
      openUrl(baiduUrlString)
    }
    
    func openGaoDeMap(keyword:String) {
        let gaodeUrlString = String(format:"iosamap://arroundpoi?sourceApplication=applicationName&keywords=%@&lat=36.2&lon=116.1&dev=0",keyword)
        openUrl(gaodeUrlString)
    }
    
    func openSyatemMap(keyword:String) {
        let systemUrlString = String(format:"http://maps.apple.com/?q=%@",keyword)
        openUrl(systemUrlString)
    }
    func openQQMap(keyword:String) {
        let systemUrlString = String(format:"http://apis.map.qq.com/uri/v1/search?keyword=%@&center=39.908491,116.374328&radius=1000&referer=myapp",keyword)
        openUrl(systemUrlString)
    }
    
   public func showMapActionSheet(keyword:String) {
        let alertController = UIAlertController(title: nil, message: nil,preferredStyle: .ActionSheet)
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"baidumap://")!)) {
            let clickBaiDuMap = UIAlertAction(title: "百度地图", style: .Default, handler: {
                (action: UIAlertAction) -> Void in
                UIApplication.sharedApplication().openBaiDuMap(keyword)
            })
            alertController.addAction(clickBaiDuMap)
        }
        
//        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
//            let clickGoogleMap = UIAlertAction(title: "谷歌地图", style: .Default, handler: {
//                (action: UIAlertAction) -> Void in
//                UIApplication.sharedApplication().openGoogleMap(keyword)
//            })
//            alertController.addAction(clickGoogleMap)
//        }
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"iosamap://")!)) {
            let clickBGaoDeMap = UIAlertAction(title: "高德地图", style: .Default, handler: {
                (action: UIAlertAction) -> Void in
                UIApplication.sharedApplication().openGaoDeMap(keyword)
            })
            alertController.addAction(clickBGaoDeMap)
        }
    
      if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"sosomap://")!)) {
        let clickQQMap = UIAlertAction(title: "腾讯地图", style: .Default, handler: {
            (action: UIAlertAction) -> Void in
            UIApplication.sharedApplication().openGaoDeMap(keyword)
        })
        alertController.addAction(clickQQMap)
     }
    
        let clickSystemMap = UIAlertAction(title: "苹果地图", style: .Default, handler: {
            (action: UIAlertAction) -> Void in
            UIApplication.sharedApplication().openBaiDuMap(keyword)
        })
        alertController.addAction(clickSystemMap)

    
       let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {
        (action: UIAlertAction) -> Void in
       })
    alertController.addAction(cancelAction)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
}
