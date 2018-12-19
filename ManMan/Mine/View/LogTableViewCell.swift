//
//  LogTableViewCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/18.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {
    
    var line = UIView()
    var icon = UIImageView()
    var title = UILabel()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: 56)
        //self.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        self.addSubview(line)
        self.addSubview(icon)
        self.addSubview(title)
        
        line.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(32)
            make.width.equalTo(2)
            make.height.equalToSuperview()
        }
        line.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.54)
        
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
    
//    override func layoutSubviews() {
//        <#code#>
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
