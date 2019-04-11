//
//  LogInViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/21.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    var imageView = UIView()
    let iconView = UIImageView()
    let loginButton = UIButton()
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        self.setImageView()
    }
    
    func setImageView() {
        self.view.addSubview(imageView)
        
        imageView.addSubview(iconView)
        imageView.addSubview(loginButton)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(SCREENSIZE.width)
            make.bottom.equalTo(-inset.bottom)
        }
        imageView.backgroundColor = UIColor(patternImage: UIImage(named:"login")!)
        
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(UIScreen.main.bounds.maxY/3)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        iconView.image = UIImage(named: "icon")
        
        loginButton.snp.makeConstraints { (make) in
            make.centerY.equalTo((UIScreen.main.bounds.maxY*2)/3-40)
            make.centerX.equalToSuperview()
            make.width.equalTo(SCREENSIZE.width/2)
            make.height.equalTo(55)
        }
        loginButton.layer.cornerRadius = 8
        loginButton.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        loginButton.addTarget(self, action: #selector(wxLoginBtnAction), for: .touchUpInside)
        loginButton.setTitle("微信授权登录", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
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
