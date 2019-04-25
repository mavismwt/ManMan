//
//  LogDetailViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/29.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire
import SwiftyJSON

class LogDetailViewController: UIViewController,CVCalendarViewDelegate,CVCalendarMenuViewDelegate,CVCalendarViewAppearanceDelegate,UITextViewDelegate {
    
    var topLineView = UIView()
    var leftButton = UIButton()
    var rightButton = UIButton()
    var titleView = UILabel()
    var textView = UIView()
    var inputText = UITextView()
    var monthView = UILabel()
    var cView = UIView()
    
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    
    private var menuView: CVCalendarMenuView!
    private var calendarView: CVCalendarView!
    var currentCalendar: Calendar!
    
    var strData = [String]()
    var recordStr = String()
    var allDate = [Date]()
    var selDate = Date()
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        self.getDatas()
        self.setTopLineView()
        self.setCalendarView()
        self.setLogDetailView()
    }
    
    func getDatas() {
        let URLStr = "https://slow.hustonline.net/api/v1"
        var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTY3NzU1MzYsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTU2MTcwNzM2fQ.WbTvev5bweV5OlhKRqypu5fdZmrZhBKHUpAji6N-6ng"
        let urlStr = "\(URLStr)/user"
        let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
        
        Alamofire.request(urlStr, method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { response in
            self.recordStr = String()
            self.allDate = [Date]()
            if let value = response.result.value {
                let json = JSON(value)
                let num = json["data"]["records"].count
                for i in 0..<num {
                    let record = json["data"]["records"][i]
                    let timeMili = record["time"].int64
                    let timeInterval:TimeInterval = TimeInterval(Int(timeMili!/1000))
                    let signDate = Date(timeIntervalSince1970: timeInterval)
                    self.allDate.append(signDate)
                    self.strData.append(record["content"].string!)
                    if signDate.isSameDay(day: self.selDate) {
                        self.recordStr = record["content"].string!
                    }
                }
            }
            self.setLogDetailView()
            self.calendarView.layoutSubviews()
            self.calendarView.commitCalendarViewUpdate()
            self.calendarView.contentController.refreshPresentedMonth()
            self.view.layoutIfNeeded()
        }
    }
    
    
    func setTopLineView() {
        topLineView.addSubview(leftButton)
        topLineView.addSubview(titleView)
        
        self.view.addSubview(topLineView)
        
        let navRect = self.navigationController?.navigationBar.frame
        topLineView.frame = CGRect(x: 0, y: 0, width: (navRect?.width)!, height: (navRect?.height)!+inset.top)
        topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        titleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        titleView.text = "日志详情"
        titleView.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        titleView.font = UIFont.boldSystemFont(ofSize: 18)
        
        leftButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.left.equalTo(16)
            make.width.equalTo(15)
            make.height.equalTo(20)
        }
        leftButton.setImage(UIImage(named: "back"), for: .normal)
        leftButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    func setCalendarView() {
        currentCalendar = Calendar.init(identifier: .gregorian)
        //初始化星期菜单栏/日历
        let WidthOfCalendar = SCREENSIZE.width-28
        let navRect = self.navigationController?.navigationBar.frame
        cView.frame = CGRect(x:14, y:(navRect?.height)!+inset.top+16, width:WidthOfCalendar, height:WidthOfCalendar)
        cView.backgroundColor = UIColor.white
        cView.layer.cornerRadius = 8
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOffset = CGSize(width: 3, height: 6)
        monthView.frame = CGRect(x:0, y:8, width:WidthOfCalendar, height:24)
        monthView.textAlignment = .center
        monthView.text = self.getNowMonth()
        menuView = CVCalendarMenuView(frame: CGRect(x:0, y:50, width:WidthOfCalendar, height:24))
        //        menuView.backgroundColor = UIColor.white
        //        menuView.layer.cornerRadius = 8
        calendarView = CVCalendarView(frame: CGRect(x:0, y:80, width:WidthOfCalendar, height:WidthOfCalendar-80))
        //        calendarView.backgroundColor = UIColor.white
        //        calendarView.layer.cornerRadius = 8
        //        calendarView.layer.shadowColor = UIColor.black.cgColor
        //        calendarView.layer.shadowOffset = CGSize(width: 3, height: 6)
        //代理
        menuView.menuViewDelegate = self
        calendarView.calendarDelegate = self
        calendarView.calendarAppearanceDelegate = self
        //将菜单视图和日历视图添加到主视图上
        cView.addSubview(monthView)
        cView.addSubview(calendarView)
        cView.addSubview(menuView)
        self.view.addSubview(cView)
        
    }
    
    func setLogDetailView() {
        
        self.view.addSubview(textView)
        textView.addSubview(inputText)
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(calendarView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-inset.bottom-16)
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
        inputText.text = self.recordStr
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:calendar实现
    
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return false
    }
    
    func dayLabelPresentWeekdayTextColor() -> UIColor {
        return UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        return UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
//        if !dayView.isHidden && dayView.date != nil {
//            //获取该日期视图的年月日
//            let year = dayView.date.year
//            let month = dayView.date.month
//            let day = dayView.date.day
//            //判断日期是否符合要求
//            if year == 2018 && month == 12 && day >= 1 && day <= 3 {
//                return true
//            }
//        }
        return false
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame,
                                         shape: CVShape.circle)
        circleView.fillColor = UIColor.init(red: 255/255, green: 213/255, blue: 97/255, alpha: 0.3)
        dayView.dayLabel.textColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        return circleView
    }
    
//    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent)
//        -> UIColor? {
//            switch (weekDay, status, present) {
//            case (_, .selected, _), (_, .highlighted, _): return UIColor.white
//            case (.sunday, .in, _): return UIColor.black //Color.sundayText
//            case (.sunday, _, _): return UIColor.black //Color.sundayTextDisabled
//            case (_, .in, _): return UIColor.orange
//            default: return UIColor.gray
//            }
//    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        
        if !dayView.isHidden && dayView.date != nil {
            //获取该日期视图的年月日
            let year = dayView.date.year
            let month = dayView.date.month
            let day = dayView.date.day
            //判断日期是否符合要求
            //            let timeFormatter = DateFormatter()
            //            timeFormatter.dateFormat = "yyyy年MM月dd日 HH:mm"
            for i in 0..<allDate.count {
                let calendar = Calendar.current
                let unit: Set<Calendar.Component> = [.day,.month,.year]
                let comps = calendar.dateComponents(unit, from: allDate[i])
                if year == comps.year && month == comps.month && day == comps.day {
                    return true
                }
            }
            
        }
        return false
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        //        switch dayView.date.day {
        //        case 1:
        //            return [UIColor.orange]
        //        case 2:
        //            return [UIColor.orange, UIColor.green]
        //        default:
        //            return [UIColor.orange, UIColor.green, UIColor.blue]
        //        }
        return [UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)]
    }
    
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
        return 25
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 4
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        //点击日期事件
        self.getDatas()
    }
    //获取当前时间/string
    func getDateStr(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MMM.d"
        let str = timeFormatter.string(from: date) as String
        return str
    }
    //获取当前月份
    func getNowMonth() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MMMM"
        let strNowMonth = timeFormatter.string(from: date) as String
        return strNowMonth
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        //导航栏显示当前日历的年月
        var month = String()
        switch date.month {
        case 1:
            month = "January"
            break
        case 2:
            month = "February"
            break
        case 3:
            month = "March"
            break
        case 4:
            month = "April"
            break
        case 5:
            month = "May"
            break
        case 6:
            month = "June"
            break
        case 7:
            month = "July"
            break
        case 8:
            month = "Augest"
            break
        case 9:
            month = "September"
            break
        case 10:
            month = "October"
            break
        case 11:
            month = "November"
            break
        case 12:
            month = "December"
            break
        default:
            break
        }
        self.monthView.text = month
        //date.globalDescription
        //self.datas[0].title = "\(month) \(date.day)"
        self.selDate = date.convertedDate()!
        self.view.layoutIfNeeded()
        self.getDatas()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
}
