//
//  FirstDateLogCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/20.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class FirstLogCell: UIView {
    
    var line = UIView()
    var dot = UIView()
    var title = UILabel()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        
        self.addSubview(line)
        self.addSubview(dot)
        self.addSubview(title)
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.centerY)
            make.left.equalTo(32)
            make.bottom.equalToSuperview()
            make.width.equalTo(2)
        }
        line.backgroundColor = UIColor.init(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        
        dot.snp.makeConstraints { (make) in
            make.centerX.equalTo(line.snp.centerX)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(12)
        }
        dot.layer.cornerRadius = 6
        dot.clipsToBounds = true
        dot.backgroundColor = UIColor.init(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(line.snp.right).offset(16)
            make.height.equalTo(24)
        }
        title.font = UIFont.systemFont(ofSize: 24)
        title.text = "喝水"
        title.textColor = UIColor.init(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(check))
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func check(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

