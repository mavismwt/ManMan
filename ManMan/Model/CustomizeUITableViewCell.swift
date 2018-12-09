//
//  CustomizeUITableViewCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/5.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import SnapKit

class CustomizeUITableViewCell: UITableViewCell {
    
    let SCREENRECT = UIScreen.main.bounds
    
    struct flagData {
        var profileURL = "UIImageView()"
        var nicknameText = "UILabel()"
        var detailText = "UITextView()"
        var comment = [{
            var userName = ""
            var userComment = ""
        }]
        var commentNumText = "UILabel()"
        var likeNumText = "UILabel()"
    }

    var cell = UIView()
    var basicInfo = UIView()
    var commentView = UIView()
    var profile = UIImageView()
    var nickname = UILabel()
    var time = UILabel()
    var detail = UITextView()
    var commentImg = UIImageView()
    var commentNum = UILabel()
    var likeImg = UIImageView()
    var likeNum = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        basicInfo.addSubview(profile)
        basicInfo.addSubview(nickname)
        basicInfo.addSubview(time)
        
        commentView.addSubview(commentImg)
        commentView.addSubview(commentNum)
        commentView.addSubview(likeImg)
        commentView.addSubview(likeNum)
        
        cell.addSubview(basicInfo)
        cell.addSubview(detail)
        cell.addSubview(commentView)
        
        self.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 0.8)
        self.addSubview(cell)
            
        cell.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(8)
            make.height.equalTo(151)
        }
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 3, height: 6)
        
        basicInfo.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.equalTo(SCREENRECT.size.width)
            make.height.equalTo(68)
        }
        
        profile.image = UIImage(named: "MyProfile")
        profile.layer.cornerRadius = 20
        profile.clipsToBounds = true
        profile.backgroundColor = UIColor.orange
        profile.snp.makeConstraints{(make) in
            make.top.equalTo(12)
            make.left.equalTo(20)
            make.width.height.equalTo(40)
        }
        
        nickname.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(80)
            make.height.equalTo(17)
        }
        nickname.font = UIFont(name: "PingFang SC", size: 17)
        nickname.textColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.87)
        nickname.text = "mavismwt"
        
        time.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(35)
            make.left.equalToSuperview().offset(80)
            make.height.equalTo(15)
        }
        time.font = UIFont(name: "PingFang SC", size: 10)
        time.textColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.54)
        time.text = "2018年12月31日 13:00"
        
        detail.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(64)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(70)
        }
        detail.font = UIFont(name: "PingFang SC", size: 15)
        detail.isEditable = false
        detail.isSelectable = false
        detail.isOpaque = false
        detail.text = "这是我的flag这是我的flag这是我的flag这是我的flag这是我的flag这是我的flag这是我的flag这是我的flag这是我的flag"
        
        commentView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(0)
            make.width.equalTo(SCREENRECT.size.width)
            make.height.equalTo(40)
        }
        
        commentImg.snp.makeConstraints { (make) in
            make.right.equalTo(commentView.snp.right).offset(-104)
            make.bottom.equalTo(commentView.snp.bottom).offset(-13)
            make.width.height.equalTo(15)
        }
        commentImg.image = UIImage(named: "comment")
        
        commentNum.snp.makeConstraints { (make) in
            make.left.equalTo(commentImg.snp.right).offset(5)
            make.centerY.equalTo(commentImg.snp.centerY)
            make.width.equalTo(20)
            make.height.equalTo(12)
        }
        commentNum.font = UIFont(name: "PingFang SC", size: 12)
        commentNum.textColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.54)
        commentNum.text = "33"
        
        likeImg.snp.makeConstraints { (make) in
            make.right.equalTo(commentView.snp.right).offset(-52)
            make.bottom.equalTo(commentView.snp.bottom).offset(-13)
            make.width.height.equalTo(15)
        }
        likeImg.image = UIImage(named: "like")
        
        likeNum.snp.makeConstraints { (make) in
            make.left.equalTo(likeImg.snp.right).offset(5)
            make.centerY.equalTo(likeImg.snp.centerY)
            make.width.equalTo(20)
            make.height.equalTo(12)
        }
        likeNum.font = UIFont(name: "PingFang SC", size: 12)
        likeNum.textColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.54)
        likeNum.text = "33"
    }
    
    func setValueForCell(flag:flagData){
        profile.image = UIImage(named: flag.profileURL)
        nickname.text = flag.nicknameText
        detail.text = flag.detailText
        commentNum.text = flag.commentNumText
        likeNum.text = flag.likeNumText
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(code:)has not brrn implomented");
    }
}
