//
//  SettingTableViewCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/15.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    var cell = UIView()
    var title = UILabel()
    var setting = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cell.addSubview(title)
        cell.addSubview(setting)
        
        self.addSubview(cell)
        
        cell.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(56)
        }
        cell.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 3, height: 6)
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(16)
            make.height.equalTo(17)
        }
        title.font = UIFont.systemFont(ofSize: 17)
        title.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.87)
        title.text = "我的"
        
        setting.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(42)
            make.height.equalTo(24)
        }
        setting.onTintColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 0.35)
        setting.tintColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        setting.thumbTintColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 72)
        self.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

