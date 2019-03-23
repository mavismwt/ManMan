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
            WXLoginSuccess(res: response.code!)
        }
    }
    
    private func WXLoginSuccess(res:String){
        let code = res
//        let AppID = "wx7ef876fe1742f5df"
//        let AppSecret = "7842d96f93d4116b247a6d38c8824c29"
        let urlStr = "https://slow.hustonline.net/api/v1/user/login"
        
        var token = String()
        //登录
        Alamofire.request(urlStr,method: .post,parameters:["code": code]).responseJSON { response in
            let value = response.result.value
            print("value:\(value)")
            let json = JSON(value)
            if let token = json["token"].string {
                print("token:\(token)")
                UserDefaults.standard.set(token, forKey: "token")
            }
        }
        //获取用户信息
//
        
        
//
//        Alamofire.request(url).responseJSON { response in
//            switch response.result.isSuccess {
//            case true:
//                if let value = response.result.value {
//                    print(response.result.value as Any)
//                    let json = JSON(value)
//                    let accessToken = json[0]["access_token"].string
//                    let openID = json[0]["openid"].string
//                    if ((accessToken != nil) && (openID != nil)){
//                        print("assessToken:\(accessToken)")
//                        print("openID:\(openID)")
//                        self.requestUserInfo(accessToken!,openID: openID!)
//                    }
//                }
//            case false:
//                print(response.result.error)
//            }
//
//        }

    }
}

