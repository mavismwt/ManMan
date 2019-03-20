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
    var text = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bt = UIButton(frame: CGRect(x: 100, y: 200, width: 200, height: 100))
        bt.backgroundColor = UIColor.green
        print("ok")
        bt.addTarget(self, action: #selector(wxLoginBtnAction), for: .touchUpInside)
        
        
        text = UITextField(frame: CGRect(x: 50, y: 400, width: 300, height: 200))
        text.text = "here"
        text.backgroundColor = UIColor.blue
        
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(bt)
        //self.view.addSubview(text)
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
                print("okokokkkkk")
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!)
            }
        }
    }
    
    func test() {
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        print("lii")
//        if let str = UserDefaults.standard.value(forKey: "user") {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.text.text = str as! String
//            })
//        }
//    }
}

