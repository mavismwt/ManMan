//
//  CheckCardCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/9.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class CheckCardCell: UITableViewCell {
    
    var cell = UIView()
    var taskIcon = UIImageView()
    var taskName = UILabel()
    var taskProcess = UILabel()
    var checkButton = UIImageView()
    var background = UIImageView()
    var deleteButton = UIButton()
    var backgroundImage = UIImageView()
    var checkImg = UIImageView()
    var days:Int = 0
    var isfinished = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cell.addSubview(backgroundImage)
        cell.addSubview(background)
        cell.addSubview(taskIcon)
        cell.addSubview(taskName)
        cell.addSubview(taskProcess)
        cell.addSubview(checkButton)
        self.addSubview(cell)
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 95)
        self.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        cell.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(4)
            make.height.equalTo(87)
        }
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 3, height: 6)

        taskIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(cell.snp.centerY)
            make.left.equalTo(16)
            make.width.height.equalTo(56)
        }
        taskIcon.image = UIImage(named: "dateSelected")
        
        taskName.snp.makeConstraints { (make) in
            make.top.equalTo(26)
            make.left.equalTo(88)
            make.height.equalTo(17)
        }
        taskName.text = "喝水"
        taskName.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.87)
        taskName.font = UIFont.boldSystemFont(ofSize: 17)
        
        taskProcess.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.left.equalTo(88)
            make.height.equalTo(12)
        }
        taskProcess.text = "已坚持\(days)天"
        taskProcess.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.54)
        taskProcess.font = UIFont.systemFont(ofSize: 12)
        
        checkButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(34)
        }
        checkButton.image = UIImage(named: "check")
        
        background.snp.makeConstraints { (make) in
            make.left.top.width.height.equalToSuperview()
        }
        background.backgroundColor = UIColor.white
        
        backgroundImage.snp.makeConstraints { (make) in
            make.left.top.width.height.equalToSuperview()
        }
        backgroundImage.image = UIImage(named: "checked")
        
        checkImg.frame = CGRect()
        
    }
    
    
    
    @objc func check() {
//        background.removeFromSuperview()
//        checkButton.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        taskProcess.text = "已坚持\(days)天"
        if isfinished == true {
            taskProcess.text = "已坚持\(days)天"
            background.layer.opacity = 0//removeFromSuperview()
            checkButton.layer.opacity = 0//removeFromSuperview()
        }
        else {
            taskProcess.text = "已坚持\(days)天"
            background.layer.opacity = 1//removeFromSuperview()
            checkButton.layer.opacity = 1//removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
