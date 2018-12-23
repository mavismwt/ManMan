//
//  CommentDetailView.swift
//  ManMan
//
//  Created by Apple on 2018/12/23.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
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
    var basicInfo = UIView()
    var profile = UIImageView()
    var nickname = UILabel()
    var detail = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        basicInfo.addSubview(profile)
        basicInfo.addSubview(nickname)
        
        self.addSubview(basicInfo)
        self.addSubview(detail)
        
        let height = CommentTableViewCell.heightForTextView(textView: detail, fixedWidth: SCREENRECT.size.width-90)
        
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
            make.centerY.equalTo(profile.snp.centerY)
            make.left.equalToSuperview().offset(80)
            make.height.equalTo(14)
        }
        nickname.font = UIFont(name: "PingFang SC", size: 14)
        nickname.textColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.87)
        nickname.text = "mavismwt"
        
        
        detail.text = "这是我的flag这是我的flag这是我的flag这是我的flag这是我的flag这是我的flag这是我的flag这是我的flag这是我的flag"
        detail.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(64)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(height*2)
        }
        detail.font = UIFont(name: "PingFang SC", size: 14)
        detail.isEditable = false
        detail.isSelectable = false
        detail.isOpaque = false
        
        self.frame = CGRect(x: 0, y: 0, width: SCREENRECT.size.width-64, height: height+64)
        self.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 0.8)
    }
    
    
    
    func setValueForCell(flag:flagData){
        profile.image = UIImage(named: flag.profileURL)
        nickname.text = flag.nicknameText
        detail.text = flag.detailText
    }
    
    internal class func heightForTextView(textView: UITextView, fixedWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let constraint = textView.sizeThatFits(size)
        return constraint.height
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(code:)has not brrn implomented");
    }
}

