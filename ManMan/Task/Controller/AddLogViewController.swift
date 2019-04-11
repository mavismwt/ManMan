//
//  AddLogViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/9.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddLogViewController: UIViewController,UITextViewDelegate {
    
    var topLineView = UIView()
    var leftButton = UIButton()
    var rightButton = UIButton()
    var titleView = UILabel()
    var textView = UIView()
    var inputText = UITextView()
    var textLabel = UILabel()
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    
    var request = RequestFunction()
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(leftButton)
        topLineView.addSubview(rightButton)
        topLineView.addSubview(titleView)
        textView.addSubview(inputText)
        
        self.view.addSubview(textView)
        self.view.addSubview(textLabel)
        self.view.addSubview(topLineView)
        
        let navRect = self.navigationController?.navigationBar.frame
        topLineView.frame = CGRect(x: 0, y: 0, width: (navRect?.width)!, height: (navRect?.height)!+inset.top)
        topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        titleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        titleView.text = "新建日志"
        titleView.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        titleView.font = UIFont.boldSystemFont(ofSize: 18)
        
        leftButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.left.equalTo(16)
            make.width.equalTo(15)
            make.height.equalTo(20)
        }
        leftButton.setImage(UIImage(named: "back"), for: .normal)
        leftButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.right.equalTo(-16)
            make.width.equalTo(52)
            make.height.equalTo(14)
        }
        rightButton.setTitle("Done", for: .normal)
        //rightButton.setImage(UIImage(named: "back"), for: .normal)
        rightButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo((navRect?.height)!+inset.top+16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(SCREENSIZE.height/2)
        }
        textView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.87)
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        
        inputText.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.top.left.equalTo(16)
            make.bottom.right.equalTo(-16)
        }
        inputText.font = UIFont.systemFont(ofSize: 15)
        
        textLabel.snp.makeConstraints { (make) in
            make.right.equalTo(textView.snp.right)
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.height.equalTo(10)
        }
        textLabel.text = "可写280字，已写120字"
        textLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        textLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTUyNDc1NzMsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTU0NjQyNzczfQ.m6i6TH7mK34cA0oc6P9Dc_xKxQWwOoch8VdgGPrwt2k"
        request.postRecord(content: self.inputText.text, token: token)
       
    }
    
    
}

