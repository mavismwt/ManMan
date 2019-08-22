//
//  LoadView.swift
//  ManMan
//
//  Created by Apple on 2018/12/21.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class LoadView: UIView {
    
    var imageView = UIImageView()
    var textView = UITextView()
    var userInfo = UserInfo()
    
    var nickname = ""
    var greet = ""
    var day = ""
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = UIScreen.main.bounds
        self.addSubview(imageView)
        
//        let now = Date()
//        let dformatter = DateFormatter()
//        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//        print("当前日期时间：\(dformatter.string(from: now))")
       
        if let data = UserDefaults.standard.value(forKey: "userInfo") {
            let decoder = JSONDecoder()
            let obj = try? decoder.decode(UserInfo.self, from: data as! Data)
            self.userInfo = obj!
            if let name = self.userInfo.name {
                self.nickname = name
            }
        }
        
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(inset.top+58)
            make.right.equalToSuperview()
            make.width.equalTo(226)
            make.height.equalTo(234)
        }
        
        //获取当前时间
        let now = Date()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年M月d日"
        day = dformatter.string(from: now)
        let jugmentResult = judgeDateByStartAndEnd(startStr: "18:00", endStr: "6:00", dateDay: "星期一,星期二,星期三,星期四,星期五,星期六,星期日")
        var img = UIImage()
        if jugmentResult == true {
            img = UIImage(named: "night")!
            greet = "晚安"
            textView.textColor = UIColor.init(red: 255/255, green: 239/255, blue: 195/255, alpha: 1)
            self.backgroundColor = UIColor.init(red: 126/255, green: 127/255, blue: 155/255, alpha: 1)
        }else {
            img = UIImage(named: "day")!
            greet = "日安"
            textView.textColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
            self.backgroundColor = UIColor.white
        }
        imageView.image = img
        
        self.addSubview(textView)
        if nickname == "" {
            textView.text = "Hi，\n\n\(greet)。\n\n今天是\(day),\n\n很高兴陪在你身边。"
        } else {
            textView.text = "Hi \(nickname)，\n\n\(greet)。\n\n今天是\(day),\n\n很高兴陪在你身边。"
        }
        textView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
//        textView.snp.makeConstraints { (make) in
//            make.left.equalTo(41)
//            //make.top.equalTo(0)
//            make.bottom.equalTo(-25-inset.bottom)
//            make.width.equalTo(300)
//            make.height.equalTo(300)
//        }
        textView.frame = CGRect(x: 41, y: 400, width: 300, height: 600)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isEditable = false
        textView.isSelectable = false
        
        
    }
    //判断当前时间是否在某个时间段内
    func judgeDateByStartAndEnd(startStr : String, endStr : String, dateDay : String)->Bool{
        
        var today = Date()
        //let todayDay = TimeAndDateOperation.getweekDayWithDate(today)
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = "HH:mm"
        
        //将日期转换成字符串
        let todayStr = dateFormat.string(from: today)
        //转换成date类型。日期置为方法默认日期
        today = dateFormat.date(from: todayStr)!
        
        //start end 格式 "2016-05-18 9:00"
        let start = dateFormat.date(from: startStr)
        let end = dateFormat.date(from: endStr)
        
        //比对日期
        //1、对比是否是选中的星期中
        
        //if dateDay.contains(todayDay) {
            let orderResult : ComparisonResult = (start?.compare(end!))!
            switch orderResult{
            case ComparisonResult.orderedAscending://end未过24点
                if ((today.compare(start!)==ComparisonResult.orderedDescending)&&(today.compare(end!)==ComparisonResult.orderedAscending))||((today.compare(start!)==ComparisonResult.orderedDescending)&&(today.compare(end!)==ComparisonResult.orderedSame))||((today.compare(start!)==ComparisonResult.orderedSame)&&(today.compare(end!)==ComparisonResult.orderedAscending)) {
                    return true
                }else{
                    return false
                }
            case ComparisonResult.orderedDescending://end过24点
                if ((today.compare(start!)==ComparisonResult.orderedDescending)&&(today.compare(end!)==ComparisonResult.orderedDescending))||((today.compare(start!)==ComparisonResult.orderedAscending)&&(today.compare(end!)==ComparisonResult.orderedAscending))||((today.compare(start!)==ComparisonResult.orderedSame)&&(today.compare(end!)==ComparisonResult.orderedDescending))||((today.compare(start!)==ComparisonResult.orderedAscending)&&(today.compare(end!)==ComparisonResult.orderedSame)) {
                    return true
                }else{
                    return false
                }
            default:
                return false
            }
//        }else{
//            return false
//        }
    }
    
    override func layoutSubviews() {
        textView.text = "Hi \(nickname),\n\n\(greet)。\n\n今天是\(day),\n\n很高兴陪在你身边。"
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
