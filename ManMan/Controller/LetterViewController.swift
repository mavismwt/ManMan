//
//  LetterViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/9.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class LetterViewController: UIViewController {
    
    var topLineView = UIView()
    var leftButton = UIButton()
    var rightButton = UIButton()
    var titleView = UILabel()
    var letterHeader = UITextField()
    var letterBody = UITextView()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(leftButton)
        topLineView.addSubview(rightButton)
        topLineView.addSubview(titleView)
        
        self.view.addSubview(topLineView)
        self.view.addSubview(letterHeader)
        self.view.addSubview(letterBody)
        
        topLineView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(SCREENSIZE.width)
            make.height.equalTo(70)
        }
        //topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        titleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        titleView.text = "写给一年后的自己"
        titleView.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        titleView.font = UIFont.boldSystemFont(ofSize: 18)
        
        leftButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(10)
            make.left.equalTo(16)
            make.width.height.equalTo(20)
        }
        leftButton.setImage(UIImage(named: "backBlack"), for: .normal)
        leftButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(10)
            make.right.equalTo(-16)
            make.width.height.equalTo(20)
        }
        rightButton.setImage(UIImage(named: "send"), for: .normal)
        rightButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        letterHeader.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.equalTo(91)
            make.height.equalTo(18)
        }
        letterHeader.text = "To:一年后的自己"
        letterHeader.font = UIFont.systemFont(ofSize: 16)
        
        letterBody.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.equalTo(letterHeader.snp.bottom).offset(40)
            make.bottom.equalToSuperview()
        }
        letterBody.backgroundColor = UIColor.clear
        letterBody.text = "blablablabla"
        letterBody.font = UIFont.systemFont(ofSize: 16)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
