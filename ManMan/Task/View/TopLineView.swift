//
//  TopLineView.swift
//  ManMan
//
//  Created by Apple on 2019/4/24.
//  Copyright © 2019 Mavismwt. All rights reserved.
//

import UIKit

class TopLineView: UIView {
    
    var leftButton = UIButton()
    var rightButton = UIButton()
    var titleView = UILabel()
    
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.addSubview(titleView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
