//
//  LogDetailViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/29.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import CVCalendar

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
    
    struct Log {
        var time:String?
        var detail:String?
    }
    var logs = [Log.init(time: "1", detail: "今天真是快乐的一天啊！"),Log.init(time: "2", detail: "是做了实验吃了锅包肉的一天"),Log.init(time: "3", detail: "遇到了那个他")]
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        
        self.setTopLineView()
        self.setCalendarView()
        self.setLogDetailView()
    }
    
    func setTopLineView() {
        topLineView.addSubview(leftButton)
        //topLineView.addSubview(rightButton)
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
        
//        rightButton.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview().offset(10)
//            make.right.equalTo(-16)
//            make.height.equalTo(20)
//        }
//        rightButton.setTitle("Done", for: .normal)
//        rightButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    func setCalendarView() {
//        currentCalendar = Calendar.init(identifier: .gregorian)
//        //初始化星期菜单栏/日历
//        let WidthOfCalendar = SCREENSIZE.width-28
//        let navRect = self.navigationController?.navigationBar.frame
//        menuView = CVCalendarMenuView(frame: CGRect(x:14, y:(navRect?.height)!+inset.top+16, width:WidthOfCalendar, height:15))
//        calendarView = CVCalendarView(frame: CGRect(x:14, y:(navRect?.height)!+inset.top+16, width:WidthOfCalendar, height:WidthOfCalendar))
//        calendarView.backgroundColor = UIColor.white
//        calendarView.layer.cornerRadius = 8
//        calendarView.layer.shadowColor = UIColor.black.cgColor
//        calendarView.layer.shadowOffset = CGSize(width: 3, height: 6)
//        //代理
//        menuView.menuViewDelegate = self
//        calendarView.calendarDelegate = self
//        calendarView.calendarAppearanceDelegate = self
//        //将菜单视图和日历视图添加到主视图上
//        //self.view.addSubview(menuView)
//        self.view.addSubview(calendarView)
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
        if !dayView.isHidden && dayView.date != nil {
            //获取该日期视图的年月日
            let year = dayView.date.year
            let month = dayView.date.month
            let day = dayView.date.day
            //判断日期是否符合要求
            if year == 2018 && month == 12 && day >= 1 && day <= 3 {
                return true
            }
        }
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
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        //print(dayView.dayLabel.text)
        switch (dayView.dayLabel.text)! {
        case "1":
            self.inputText.text = logs[0].detail
            self.view.layoutIfNeeded()
            break
        case "2":
            self.inputText.text = logs[1].detail
            self.view.layoutIfNeeded()
            break
        case "3":
            self.inputText.text = logs[2].detail
            self.view.layoutIfNeeded()
            break
        default:
            self.inputText.text = " "
            self.view.layoutIfNeeded()
            break
        }
    }
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
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
}
