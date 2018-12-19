//
//  LastLogTableViewCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/20.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class LastLogCell: UIView {
    
    var line = UIView()
    var dot = UIView()
    var icon = UIImageView()
    var title = UILabel()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        
        self.addSubview(line)
        self.addSubview(dot)
        self.addSubview(icon)
        self.addSubview(title)
        
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY)
            make.left.equalTo(32)
            make.top.equalToSuperview()
            make.width.equalTo(2)
        }
        line.backgroundColor = UIColor.init(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        
        dot.snp.makeConstraints { (make) in
            make.centerX.equalTo(line.snp.centerX)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(8)
        }
        dot.layer.cornerRadius = 3
        dot.clipsToBounds = true
        dot.backgroundColor = UIColor.init(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        
        icon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(48)
            make.width.height.equalTo(48)
        }
        icon.image = UIImage(named: "drink")
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(8)
            make.height.equalTo(14)
        }
        title.font = UIFont.systemFont(ofSize: 14)
        title.text = "喝水"
        title.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.74)
        
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

