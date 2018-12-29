//
//  CommentLineViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/20.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class CommentLineView: UIView {
    
    var inputText = UITextField()
    var sendButton = UIButton()
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(inputText)
        self.addSubview(sendButton)
        
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-60-inset.bottom, width: UIScreen.main.bounds.width, height: 60)
        self.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        inputText.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-56)
            make.height.equalTo(40)
        }
        inputText.backgroundColor = UIColor.white
        inputText.placeholder = "发表评论"
        inputText.borderStyle = .none
        inputText.layer.cornerRadius = 20
        inputText.clipsToBounds = true
        
        sendButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
            make.width.height.equalTo(34)
        }
        sendButton.setImage(UIImage(named: "send"), for: .normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
