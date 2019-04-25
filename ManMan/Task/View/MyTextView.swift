//
//  MyTextView.swift
//  ManMan
//
//  Created by Apple on 2019/4/24.
//  Copyright © 2019 Mavismwt. All rights reserved.
//

import UIKit

class MyTextView: UIView, UITextViewDelegate {
    
    var textView = UIView()
    var inputText = UITextView()
    var textLabel = UILabel()
    
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    
    var textCount = Int()
    var textStr = String()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textView.addSubview(inputText)
        self.addSubview(textView)
        self.addSubview(textLabel)
        
        textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(SCREENSIZE.height/2)
        }
        textView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.87)
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        
        inputText.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.top.left.equalTo(16)
            make.bottom.right.equalTo(-16)
        }
        inputText.font = UIFont.systemFont(ofSize: 15)
        inputText.delegate = self
        
        textLabel.snp.makeConstraints { (make) in
            make.right.equalTo(textView.snp.right)
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.height.equalTo(10)
        }
        textLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        textLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location >= 280{
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textCount = textView.text.count
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        inputText.text = textStr
        textLabel.text = "可写280字，已写\(textCount)字"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
