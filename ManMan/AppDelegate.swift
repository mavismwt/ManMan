//
//  AppDelegate.swift
//  ManMan
//
//  Created by Apple on 2018/12/5.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let homeViewController = HomeViewController()
        let mineViewController = MineViewController()
        let firstNavigationController = UINavigationController(rootViewController: homeViewController)
        let secondNavigationController = UINavigationController(rootViewController: mineViewController)
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [firstNavigationController,secondNavigationController]
        let testViewController = TestViewController()
        window?.rootViewController = testViewController
        //window?.rootViewController = tabbarController
        //MARK: -注册微信
        //let WXAppID = "wx7ef876fe1742f5df"
        WXApi.registerApp("wx7ef876fe1742f5df")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlKey: String = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String
        if urlKey == "com.tencent.xin" {
            // 微信的回调
            return WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
    
//    //  微信跳转回调
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        WXApi.handleOpen(url, delegate: self)
//        return true
//    }
    
    //  微信回调
    func onResp(_ resp: BaseResp){
        //  微信登录回调
        if resp.errCode == 0 && resp.type == 0{//授权成功
            let response = resp as! SendAuthResp
            
            //  微信登录成功通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"), object: response.code)
            let noti = Notification(name: Notification.Name(rawValue: "WXLoginSuccessNotification"))
            WXLoginSuccess(code1: response.code!)
        }
    }
    
    //  微信成功通知
    func WXLoginSuccess(code1:String){
        let code = code1
//    func WXLoginSuccess(notification:Notification) {
//        print(notification.object)
//        if let code = notification.object {
        let AppID = "wx7ef876fe1742f5df"
        let AppSecret = "7842d96f93d4116b247a6d38c8824c29"
        let url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(AppID)&secret=\(AppSecret)&code=\(code)&grant_type=authorization_code"
        //获取access_token
        Alamofire.request(url).responseJSON { response in
            print(response.result.value)
            //let JSON = response.result.value
            //UserDefaults.standard.set(JSON, forKey: "user")
            }
            
//        request().responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//        RequestTool.GETRequestWith(url, success: { (task, data) in
//            print(data)
//        }) { (task, error) in
//            print(error)
//        }
    }
}

