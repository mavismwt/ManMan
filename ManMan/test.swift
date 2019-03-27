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
    
    @objc func req() {
        
        let urlRequst = ()
        
        
        if let token = UserDefaults.standard.value(forKey: "token") {
            //let headers:HTTPHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTQwMDA4MTgsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTUzMzk2MDE4fQ.m_mjQURafkbSVKGCeuRn79dTY7Gbb0uYmdot1-w_Lek"]
            let URLStr = "https://slow.hustonline.net/api/v1/user"
            let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
            Alamofire.request("https://slow.hustonline.net/api/v1/user", method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { response in
                //print(request)
                print(response)
                print(response.request?.httpBody)
                print(response.request?.allHTTPHeaderFields)
            }
                .validate { request, response, data in
                    print(request?.allHTTPHeaderFields)
                    // Custom evaluation closure (no access to server data)
                    return .success
            }
        }
        
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
    
//    @objc func req() {
//        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTM2OTExNjcsImlkIjoiIiwib3JpZ19pYXQiOjE1NTMwODYzNjd9.yjBm75SsyUjq-fu3Kyi8p8Kqycq8ObvQogKPv96aRE0"
//        let AppID = "wx7ef876fe1742f5df"
//        let AppSecret = "7842d96f93d4116b247a6d38c8824c29"
//        let urlStr = "https://slow.hustonline.net/api/v1/record/action/insert"
//        let parameter:Parameters = ["code": code]
//        //获取access_token
//        print(token)
//        Alamofire.request(urlStr,method: .post,parameters:["code": code]).responseJSON { response in
//            let value = response.result.value
//            print(value)
//        }
//    }
    
//    var milliStamp : String {
//        let timeInterval: TimeInterval = self.timeIntervalSince1970
//        let millisecond = CLongLong(round(timeInterval*1000))
//        return "\(millisecond)"
//    }
    
}

