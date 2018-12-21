//
//  LoadView.swift
//  ManMan
//
//  Created by Apple on 2018/12/21.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class LoadView: UIView {
    
    var backgroundView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView.frame = UIScreen.main.bounds
        var img = UIImage(named: "login")
        img = img?.reSizeImage(reSize: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        backgroundView.image = img
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.addSubview(backgroundView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
