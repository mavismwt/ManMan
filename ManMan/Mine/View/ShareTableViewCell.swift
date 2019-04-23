//
//  ShareTableViewCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/29.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class ShareTableViewCell: UITableViewCell {
    
    var icon = UIImageView()
    var title = UILabel()
    var status = UILabel()
    var days:Int = 0
    
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //self.frame = frame
        self.frame = CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: 64)
        //self.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        self.addSubview(icon)
        self.addSubview(title)
        self.addSubview(status)
        
        icon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(48)
            make.width.height.equalTo(48)
        }
        icon.image = UIImage(named: "drink")
        icon.layer.cornerRadius = 24
        icon.clipsToBounds = true
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(8)
            make.height.equalTo(16)
        }
        title.font = UIFont.systemFont(ofSize: 16)
        //title.text = "喝水"
        title.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.74)
        
        status.snp.makeConstraints { (make) in
            make.bottom.equalTo(title.snp.bottom)
            make.left.equalTo(title.snp.right).offset(8)
            make.height.equalTo(14)
        }
        status.font = UIFont.systemFont(ofSize: 16)
        status.text = "已坚持\(self.days)天"
        status.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.74)
        
    }
    
    override func layoutSubviews() {
        status.text = "已坚持\(self.days)天"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

