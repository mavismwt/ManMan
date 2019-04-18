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
    let function = RequestFunction()
    var bt = UIButton()
    var bt2 = UIButton()
    var text = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bt = UIButton(frame: CGRect(x: 100, y: 200, width: 200, height: 80))
        bt.backgroundColor = UIColor.green
        bt.addTarget(self, action: #selector(wxLoginBtnAction), for: .touchUpInside)
        bt.setTitle("授权登录", for: .normal)

        
        bt2 = UIButton(frame: CGRect(x: 100, y: 400, width: 200, height: 80))
        bt2.backgroundColor = UIColor.green
        bt2.addTarget(self, action: #selector(req), for: .touchUpInside)
        bt2.setTitle("获取信息", for: .normal)
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(bt)
        self.view.addSubview(bt2)
        
    }
    
//    @objc func req() {
//
//        let urlRequst = ()
//
//
//        if let token = UserDefaults.standard.value(forKey: "token") {
//            //let headers:HTTPHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTQwMDA4MTgsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTUzMzk2MDE4fQ.m_mjQURafkbSVKGCeuRn79dTY7Gbb0uYmdot1-w_Lek"]
//            let URLStr = "https://slow.hustonline.net/api/v1/user"
//            let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
//            Alamofire.request("https://slow.hustonline.net/api/v1/user", method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { response in
//                //print(request)
//                print(response)
//                print(response.request?.httpBody)
//                print(response.request?.allHTTPHeaderFields)
//            }
//                .validate { request, response, data in
//                    print(request?.allHTTPHeaderFields)
//                    // Custom evaluation closure (no access to server data)
//                    return .success
//            }
//       }
//
//    }
    
    @objc func req() {
        //function.getUserInfo(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTQ2MjIwMzQsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTU0MDE3MjM0fQ.5QRNwSvgTWdwv1ONNsmKId93aJAHpprXvQlBpqUO_pA")
        function.postRoutine(title: "喝水", icon: "drink", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTYxNTcyODEsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTU1NTUyNDgxfQ.UB5ASV9pM4SO1WP1le1ZyLQtlOjzcOtl8tq3gyOW1rU")
        //function.postRecord(content: "just", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTYxNTcyODEsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTU1NTUyNDgxfQ.UB5ASV9pM4SO1WP1le1ZyLQtlOjzcOtl8tq3gyOW1rU")
        
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
    
}

