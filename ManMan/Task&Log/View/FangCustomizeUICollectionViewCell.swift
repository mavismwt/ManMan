//
//  FangCustomizeUICollectionViewCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class FangCustomizeUICollectionViewCell: UICollectionViewCell {
    
    var icon = UIImageView()
    var cell = UIView()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let widthOfCell = (SCREENSIZE.width-48)/3
        let heightOfCell = widthOfCell
        
        cell.addSubview(icon)
        self.addSubview(cell)
        
        self.frame = CGRect(x: 0, y: 0, width:(SCREENSIZE.width-24)/3, height: (SCREENSIZE.width-24)/3)
        
        
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
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56)
        }
        icon.image = UIImage(named: "dateSelected")
        icon.layer.cornerRadius = 28
        icon.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
