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
    var function: RequestFunction?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let homeViewController = HomeViewController()
        let mineViewController = MineViewController()
        let firstNavigationController = UINavigationController(rootViewController: homeViewController)
        let secondNavigationController = UINavigationController(rootViewController: mineViewController)
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [firstNavigationController,secondNavigationController]
        let loginViewController = LoginViewController()
        let testViewController = TestViewController()
        let token = UserDefaults.standard.value(forKey: "token") //"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTc0MTIwMDMsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTU2ODA3MjAzfQ.Bd25U4DIFoe0FrSvlqpWRLw0h6mG2to-ttNeV-Fk6nE"//UserDefaults.standard.value(forKey: "token")
        if token != nil {
            window?.rootViewController = tabbarController
        }else {
            window?.rootViewController = loginViewController
        }
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
            return WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
    
    //微信回调
    func onResp(_ resp: BaseResp){
        if resp.errCode == 0 && resp.type == 0{//授权成功
            let response = resp as! SendAuthResp
            WXLoginSuccess(res: response.code!)
        }
    }
    
    //用code获取token
    private func WXLoginSuccess(res:String){
//        let AppID = "wx7ef876fe1742f5df"
//        let AppSecret = "7842d96f93d4116b247a6d38c8824c29"
        
        let code = res
        let urlStr = "https://slow.hustonline.net/api/v1/user/login"
        
        Alamofire.request(urlStr,method: .post,parameters:["code": code]).responseJSON { response in
            let value = response.result.value
            let json = JSON(value)
            if let token = json["token"].string {
                UserDefaults.standard.set(token, forKey: "token")
                self.function?.getUserInfo()
                
            }
            response.result.ifSuccess {
                let homeViewController = HomeViewController()
                let mineViewController = MineViewController()
                let firstNavigationController = UINavigationController(rootViewController: homeViewController)
                let secondNavigationController = UINavigationController(rootViewController: mineViewController)
                let tabbarController = UITabBarController()
                tabbarController.viewControllers = [firstNavigationController,secondNavigationController]
                self.window?.rootViewController = tabbarController
            }
        }
    }
    
}

