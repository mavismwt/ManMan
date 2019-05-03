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
    
    var basicInfo = UIView()
    var profile = UIImageView()
    var nickname = UILabel()
    lazy var detail = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        basicInfo.addSubview(profile)
        basicInfo.addSubview(nickname)
        
        self.addSubview(basicInfo)
        self.addSubview(detail)
        
        basicInfo.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.equalTo(SCREENRECT.size.width)
            make.height.equalTo(36)
        }
        
        profile.image = UIImage(named: "MyProfile")
        profile.layer.cornerRadius = 10
        profile.clipsToBounds = true
        profile.backgroundColor = UIColor.orange
        profile.snp.makeConstraints{(make) in
            make.top.equalTo(8)
            make.left.equalTo(20)
            make.width.height.equalTo(20)
        }
        
        nickname.snp.makeConstraints{(make) in
            make.centerY.equalTo(profile.snp.centerY)
            make.left.equalTo(profile.snp.right).offset(8)
            make.height.equalTo(14)
        }
        nickname.font = UIFont(name: "PingFang SC", size: 14)
        nickname.textColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.87)
        nickname.text = "mavismwt"
        
        detail.text = "flag"
        let height = CommentTableViewCell.heightForTextView(textView: detail, fixedWidth: SCREENRECT.size.width-90)
        detail.snp.makeConstraints{(make) in
            make.top.equalTo(profile.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(-8)
        }
        detail.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 0)
        detail.font = UIFont(name: "PingFang SC", size: 14)
        detail.isEditable = false
        detail.isSelectable = false
        detail.isOpaque = false
        detail.isScrollEnabled = false
        
        self.frame = CGRect(x: 0, y: 0, width: SCREENRECT.size.width-64, height: height*2+32)
        self.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 0.8)
    }
    
    func setValueForCell(flag:FlagData){
        profile.image = UIImage(named: flag.profileURL!)
        nickname.text = "flag.nicknameText"
        detail.text = "flag.detailText"
    }
    
    internal class func heightForTextView(textView: UITextView, fixedWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let constraint = textView.sizeThatFits(size)
        return constraint.height
    }
    
//    override func layoutSubviews() {
//
//
//        let height = CommentTableViewCell.heightForTextView(textView: detail, fixedWidth: SCREENRECT.size.width-90)
//        detail.snp.makeConstraints{(make) in
//            make.top.equalTo(profile.snp.bottom).offset(8)
//            make.left.equalToSuperview().offset(20)
//            make.right.equalToSuperview().offset(-20)
//            make.bottom.equalTo(-8)
//        }
//        //self.frame = CGRect(x: 0, y: 0, width: SCREENRECT.size.width-64, height: height+32)
//
//    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(code:)has not brrn implomented");
    }
}

