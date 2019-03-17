//
//  test.swift
//  ManMan
//
//  Created by Apple on 2019/3/16.
//  Copyright © 2019年 Mavismwt. All rights reserved.
//

import UIKit
import Alamofire

class TestViewController: UIViewController {
    
    var bt = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bt = UIButton(frame: CGRect(x: 100, y: 200, width: 200, height: 100))
        bt.backgroundColor = UIColor.green
        bt.addTarget(self, action: #selector(wxLoginBtnAction), for: .touchUpInside)
        
        self.view.addSubview(bt)
        
    }
    
    @objc func login() {
//        // 微信登录通知
//        NotificationCenter.default.addObserver(self,selector: #selector(WXLoginSuccess(notification:)),name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"),object: nil)
    }
    //调起微信
    @objc func wxLoginBtnAction() {
        let urlStr = "weixin://"
        if UIApplication.shared.canOpenURL(URL.init(string: urlStr)!) {
            let req = SendAuthReq()
            //应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
            req.scope = "snsapi_userinfo"
            WXApi.send(req)
        }else{
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!)
            }
        }
    }
    
    func test() {}
    
    
}

