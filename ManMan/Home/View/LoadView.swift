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
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(imageView)
        
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print("当前日期时间：\(dformatter.string(from: now))")
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(inset.top+58)
            make.right.equalToSuperview()
            make.width.equalTo(226)
            make.height.equalTo(234)
        }
        var img = UIImage(named: "day")
        img = img?.reSizeImage(reSize: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        imageView.image = img
        
        let jugmentResult = LoadView.judgeDateByStartAndEnd(startStr: "15:30", endStr: "18:40", dateDay: "星期一,星期二,星期三,星期四,星期五,星期六,星期日")
        print("jugmentResult :\(jugmentResult)")

        
    }
    //判断当前时间是否在某个时间段内
    class func judgeDateByStartAndEnd(startStr : String, endStr : String, dateDay : String)->Bool{
        
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
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
