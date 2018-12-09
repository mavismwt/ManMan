//
//  ListCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/9.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    var cell = UIView()
    var title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cell.addSubview(title)
        
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
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(cell.snp.centerY)
            make.left.equalTo(16)
            make.height.equalTo(17)
        }
        title.font = UIFont.systemFont(ofSize: 17)
        title.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.87)
        title.text = "我的"
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 72)
        self.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
