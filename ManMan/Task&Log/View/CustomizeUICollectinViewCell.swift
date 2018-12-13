//
//  CustomizeUICollectinViewCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/10.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class CustomizeUICollectionViewCell: UICollectionViewCell {
    
    var icon = UIImageView()
    var title = UILabel()
    var cell = UIView()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let widthOfCell = (SCREENSIZE.width-48)/3
        let heightOfCell = widthOfCell + 20
        
        cell.addSubview(icon)
        cell.addSubview(title)
        
        self.addSubview(cell)
        
        self.frame = CGRect(x: 0, y: 0, width:(SCREENSIZE.width-24)/3, height: (SCREENSIZE.width-24)/3+20)
        
        
        cell.snp.makeConstraints { (make) in
            make.top.equalTo(4)
            make.left.equalTo(4)
            make.right.equalTo(-4)
            make.width.equalTo(widthOfCell)
            make.height.equalTo(heightOfCell)
        }
        //cell.frame = CGRect(x: 4, y: 4, width: widthOfCell, height: heightOfCell)
        cell.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 3, height: 6)
        
        icon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.width.height.equalTo(56)
        }
        icon.image = UIImage(named: "dateSelected")
        icon.layer.cornerRadius = 28
        icon.clipsToBounds = true

        title.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
        }
        title.text = "喝水"
        title.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.87)
        title.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
