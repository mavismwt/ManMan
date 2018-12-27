//
//  flagCardTableViewCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/27.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class FlagCardCell: UITableViewCell {
    
    var gotoFlag = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
        self.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        self.addSubview(gotoFlag)
        
        gotoFlag.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(50)
        }
        gotoFlag.layer.cornerRadius = 8
        gotoFlag.clipsToBounds = true
        gotoFlag.backgroundColor = UIColor.white
        gotoFlag.setTitle("设定你的本月FLAG吧！", for: .normal)
        gotoFlag.setTitleColor(UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1), for: .normal)
        gotoFlag.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        gotoFlag.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

