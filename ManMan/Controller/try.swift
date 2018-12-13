//
//  try.swift
//  ManMan
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class EViewController: UIViewController,UIScrollViewDelegate {
    
    var scrollView = UIScrollView()
    var topLineView = UIView()
    var leftButton = UIButton()
    var rightButton = UIButton()
    var titleView = UILabel()
    var but = UIButton()
    
    var tryView = UIView()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        
        scrollView.delegate = self
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: view.bounds.width*2, height: view.bounds.height*2)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        
        topLineView.addSubview(leftButton)
        topLineView.addSubview(rightButton)
        topLineView.addSubview(titleView)
        
        tryView.addSubview(but)
        scrollView.addSubview(topLineView)
        scrollView.addSubview(tryView)
        
        tryView.frame = CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: SCREENSIZE.height*1.5)
        tryView.backgroundColor = UIColor.blue
        
       // but = UIButton(frame: CGRect(x: 200, y: 400, width: 100, height: 100))
        but.snp.makeConstraints { (make) in
            make.top.equalTo(200)
            make.left.equalTo(200)
            make.width.height.equalTo(100)
        }
        but.backgroundColor = UIColor.red
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        
        
        
        self.view.addSubview(scrollView)
        
        topLineView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(SCREENSIZE.width)
            make.height.equalTo(70)
        }
        topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        titleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        titleView.text = ""
        titleView.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        titleView.font = UIFont.boldSystemFont(ofSize: 18)
        
        leftButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(10)
            make.left.equalTo(16)
            make.width.height.equalTo(20)
        }
        leftButton.setImage(UIImage(named: "back"), for: .normal)
        leftButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(10)
            make.right.equalTo(-16)
            make.width.height.equalTo(20)
        }
        rightButton.setImage(UIImage(named: "back"), for: .normal)
        rightButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
