//
//  ShowMoreView.swift
//  ManMan
//
//  Created by Apple on 2018/12/29.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class ShowMoreView: UIView {
    
    var detail = UIButton()
    var share = UIButton()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.frame = CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: SCREENSIZE.height)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        self.addSubview(detail)
        self.addSubview(share)
        
        detail.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.right.equalTo(-16)
            make.width.equalTo(153)
            make.height.equalTo(50)
        }
        detail.setTitle("查看日志详情", for: .normal)
        detail.setTitleColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.74), for: .normal)
        detail.backgroundColor = UIColor.white
        detail.layer.borderWidth = 0.1
        detail.layer.borderColor = UIColor.gray.cgColor
        detail.layer.cornerRadius = 2
        detail.clipsToBounds = true
        
        share.snp.makeConstraints { (make) in
            make.top.equalTo(detail.snp.bottom)
            make.right.equalTo(-16)
            make.width.equalTo(153)
            make.height.equalTo(50)
        }
        share.setTitle("生成今日打卡图", for: .normal)
        share.setTitleColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.74), for: .normal)
        share.backgroundColor = UIColor.white
        share.layer.borderWidth = 0.1
        share.layer.borderColor = UIColor.gray.cgColor
        share.layer.cornerRadius = 2
        share.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

