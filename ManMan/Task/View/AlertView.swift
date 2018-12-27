//
//  AlertView.swift
//  ManMan
//
//  Created by Apple on 2018/12/23.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    var imageStr = String()
    var imageView = UIImageView()
    var alertLabel = UILabel()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.frame = CGRect(x: UIScreen.main.bounds.size.width/4, y: (SCREENSIZE.height-SCREENSIZE.width/2-inset.bottom-inset.top)/2, width: SCREENSIZE.width/2, height: SCREENSIZE.width/2)
        self.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        //self.layer.shadowColor = UIColor.gray as! CGColor
        //self.layer.shadowOffset = CGSize(width: 4, height: 8)
        
        self.addSubview(imageView)
        self.addSubview(alertLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-22)
            make.width.height.equalTo(88)
        }
        imageStr = "success"
        imageView.image = UIImage(named: imageStr)
        
        alertLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        alertLabel.text = "保存成功"
        alertLabel.font = UIFont.boldSystemFont(ofSize: 24)
        alertLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.74)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
