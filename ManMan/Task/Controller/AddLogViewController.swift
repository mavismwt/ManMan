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

class AddLogViewController: UIViewController, UITextViewDelegate {
    
    var topLineView = UIView()
    var leftButton = UIButton()
    var rightButton = UIButton()
    var titleView = UILabel()
    var textView = MyTextView()
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    
    var request = RequestFunction()
    var recordID: String?
    var textStr = String()
    
    override func viewWillAppear(_ animated: Bool) {
        if let ID = UserDefaults.standard.value(forKey: "recordID"), let content = UserDefaults.standard.value(forKey: "recordContent") {
            recordID = ID as? String
            textStr = content as! String
            self.textView.textStr = textStr
            self.textView.inputText.text = textStr
        }
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(leftButton)
        topLineView.addSubview(rightButton)
        topLineView.addSubview(titleView)
        
        self.view.addSubview(textView)
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
        rightButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo((navRect?.height)!+inset.top+16)
            make.left.right.equalToSuperview()
            make.height.equalTo(SCREENSIZE.height/2+20)
        }
    }
    
    
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func post() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        if recordID != nil {
            request.putRecord(id: recordID!, content: self.textView.textStr)
            print("ox")
        } else {
            request.postRecord(content: self.textView.inputText.text)
            print("okkkk")
        }
    }
    
}

