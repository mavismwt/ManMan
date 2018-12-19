//
//  AddView.swift
//  ManMan
//
//  Created by Apple on 2018/12/9.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class AddView: UIView {
    
    var addButton = UIImageView()
    var addCheckButton = UIButton()
    var addLogButton = UIButton()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: SCREENSIZE.height)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self ,action: #selector(backToHome)))
//        self.isUserInteractionEnabled = true
        
        self.addSubview(addButton)
        self.addSubview(addCheckButton)
        self.addSubview(addLogButton)
        
        addButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(65)
        }
        addButton.image = UIImage(named: "add")
        
        addCheckButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(addButton.snp.top).offset(-16)
            make.centerX.equalTo(addButton.snp.centerX).offset(-60)
            make.width.height.equalTo(65)
        }
        addCheckButton.setImage(UIImage(named: "qian"), for: .normal)
        
        addLogButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(addButton.snp.top).offset(-16)
            make.centerX.equalTo(addButton.snp.centerX).offset(60)
            make.width.height.equalTo(65)
        }
        addLogButton.setImage(UIImage(named: "log"), for: .normal)
        
    }
    
//    @objc func backToHome() {
//
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
