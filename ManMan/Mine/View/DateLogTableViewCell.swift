//
//  DateLogTableViewCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/20.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class DateLogCell: UIView {
    
    var line = UIView()
    var dot = UIView()
    var title = UILabel()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        
        self.addSubview(dot)
        self.addSubview(title)
        self.addSubview(line)
        
        dot.snp.makeConstraints { (make) in
            make.centerX.equalTo(32)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(12)
        }
        dot.layer.cornerRadius = 6
        dot.clipsToBounds = true
        dot.backgroundColor = UIColor.init(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(dot.snp.centerX).offset(32)
            make.height.equalTo(24)
        }
        title.font = UIFont.systemFont(ofSize: 24)
        title.text = "喝水"
        title.textColor = UIColor.init(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        
        line.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(dot.snp.centerX)
            make.bottom.equalToSuperview()
            make.width.equalTo(2)
        }
        line.backgroundColor = UIColor.init(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        
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
