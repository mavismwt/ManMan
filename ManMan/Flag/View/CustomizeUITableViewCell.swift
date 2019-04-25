//
//  CustomizeUITableViewCell.swift
//  ManMan
//
//  Created by Apple on 2018/12/5.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class CustomizeUITableViewCell: UITableViewCell {
    
    let SCREENRECT = UIScreen.main.bounds

    var cell = UIView()
    var basicInfo = UIView()
    var commentView = UIView()
    var profile = UIImageView()
    var nickname = UILabel()
    var time = UILabel()
    var detail = UITextView()
    var commentImg = UIImageView()
    var commentNumLabel = UILabel()
    var commentNumber:Int = 0
    var likeView = UIView()
    var likeImg = UIImageView()
    var likeNumLabel = UILabel()
    var likeNumber:Int = 0
    var isliked = false
    
    var request = RequestFunction()
    var id = String()
    var userid = String()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        basicInfo.addSubview(profile)
        basicInfo.addSubview(nickname)
        basicInfo.addSubview(time)
        
        commentView.addSubview(commentImg)
        commentView.addSubview(commentNumLabel)
        likeView.addSubview(likeImg)
        likeView.addSubview(likeNumLabel)
        
        cell.addSubview(basicInfo)
        cell.addSubview(detail)
        cell.addSubview(commentView)
        cell.addSubview(likeView)
        
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
            make.top.equalTo(profile.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(70)
        }
        detail.gestureRecognizers?.removeAll()
        detail.font = UIFont(name: "PingFang SC", size: 15)
        detail.isEditable = false
        detail.isSelectable = false
        detail.isOpaque = false
        detail.isScrollEnabled = false
        detail.text = ""
        
        commentView.snp.makeConstraints { (make) in
            make.right.equalTo(likeView.snp.left).offset(-16)
            make.bottom.equalTo(0)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        commentImg.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        commentImg.image = UIImage(named: "comment")
        //        let commentTapGestureRecognizer = UITapGestureRecognizer()
        //        commentTapGestureRecognizer.addTarget(self, action: #selector(comment))
        //        likeView.addGestureRecognizer(commentTapGestureRecognizer)
        
        commentNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(commentImg.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(12)
        }
        commentNumLabel.font = UIFont(name: "PingFang SC", size: 12)
        commentNumLabel.textColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.54)
        
        
        likeView.snp.makeConstraints { (make) in
            make.right.equalTo(-32)
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(like))
        likeView.addGestureRecognizer(tapGestureRecognizer)
        
        likeImg.snp.makeConstraints { (make) in
            make.right.equalTo(likeNumLabel.snp.left).offset(-5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        likeNumLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(12)
        }
        likeNumLabel.font = UIFont(name: "PingFang SC", size: 12)
        likeNumLabel.textColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.54)
        likeNumLabel.text = "\(likeNumber)"
    }
    
    @objc func like() {
        if isliked == false {
            request.postFlagLike(openid: userid, flagid: id, token: "")
            isliked = true
            UIView.transition(with: self.likeImg, duration: 0.5 , options: .transitionFlipFromLeft , animations: {
                self.likeImg.image = UIImage(named: "likeSelected")
            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute:
                {
                    self.likeNumber += 1
                    self.likeNumLabel.text = "\(self.likeNumber)"
            })
        } else {
            
        }
    }
    
    @objc func comment() {
        
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//        var textWidth = SCREENRECT.size.width-64
////            UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset)
//        textWidth -= 2.0 * (textView.textContainer.lineFragmentPadding + 1);
//
//        let boundingRect = sizeOfString(string: newText, constrainedToWidth: Double(textWidth), font: textView.font!)
//        let numberOfLines = boundingRect.height / textView.font!.lineHeight;
//
//        print(numberOfLines)
//        return ((numberOfLines <= 3) && (newText.length <= 60));
//
//        }
    
    override func layoutSubviews() {
        self.commentNumLabel.text = "\(commentNumber)"
        self.likeNumLabel.text = "\(likeNumber)"
        if self.isliked {
            likeImg.image = UIImage(named: "likeSelected")
        }else {
            likeImg.image = UIImage(named: "like")
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(code:)has not brrn implomented");
    }
}
