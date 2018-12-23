//
//  try.swift
//  ManMan
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import CVCalendar

class LogViewController: UIViewController,UIScrollViewDelegate,CVCalendarViewDelegate,CVCalendarMenuViewDelegate,CVCalendarViewAppearanceDelegate {
    
    var topLineView = UIView()
    var leftButton = UIButton()
    var rightButton = UIButton()
    var titleView = UILabel()
    
    var scrollView = UIScrollView()
    var tableView = UITableView()
    var cell = LogCell()

    private var menuView: CVCalendarMenuView!
    private var calendarView: CVCalendarView!
    
    var currentCalendar: Calendar!
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    
    struct data {
        var title:String?
        var icon:String?
        var isDate:Bool?
    }
    var datas:[data] = [data.init(title: "Nov.11", icon: "", isDate: true),data.init(title: "早睡", icon: "sleep", isDate: false),data.init(title: "日志", icon: "log", isDate: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        self.loadTopLineView()
        self.setCalendarView()
        self.getData()
        self.setScrollView()
        
    }
    
    func getData() {
        for i in 0..<datas.count {
            if i == 0 {
                let cell = FirstLogCell.init(frame: CGRect(x: 0, y: 56*i, width: Int(SCREENSIZE.width), height: 56))
                cell.title.text = datas[i].title
                self.scrollView.addSubview(cell)
            }else if i == datas.count-1 {
                let cell = LastLogCell.init(frame: CGRect(x: 0, y: 56*i, width: Int(SCREENSIZE.width), height: 56))
                cell.title.text = datas[i].title
                cell.icon.image = UIImage(named: datas[i].icon!)
                self.scrollView.addSubview(cell)
            }else if datas[i].isDate! {
                let cell = DateLogCell.init(frame: CGRect(x: 0, y: 56*i, width: Int(SCREENSIZE.width), height: 56))
                cell.title.text = datas[i].title
                self.scrollView.addSubview(cell)
            }else {
                let cell = LogCell.init(frame: CGRect(x: 0, y: 56*i, width: Int(SCREENSIZE.width), height: 56))
                cell.title.text = datas[i].title
                cell.icon.image = UIImage(named: datas[i].icon!)
                self.scrollView.addSubview(cell)
            }
            
        }
        
    }
    
    func setScrollView() {
        self.view.addSubview(scrollView)
        //scrollView.frame = CGRect(x: 16, y: calendarView.frame.minY+SCREENSIZE.width-8, width: SCREENSIZE.width-32, height: SCREENSIZE.height-calendarView.frame.maxY+SCREENSIZE.width-inset.bottom)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(calendarView.snp.bottom).offset(16)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.bottom.equalTo(-inset.bottom-16)
        }
        if datas.count*56 < Int(self.view.bounds.height) {
            scrollView.contentSize = CGSize(width: self.view.bounds.width-32, height: self.view.bounds.height-70)
        }else{
            let Height = CGFloat(datas.count*56)
            scrollView.contentSize = CGSize(width: self.view.bounds.width-32, height: Height)
        }
        scrollView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        //UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        scrollView.indexDisplayMode = .alwaysHidden
        scrollView.layer.cornerRadius = 8
        scrollView.clipsToBounds = true
        scrollView.delegate = self
        
    }
    
    func setCalendarView() {
        currentCalendar = Calendar.init(identifier: .gregorian)
        //初始化星期菜单栏/日历
        let WidthOfCalendar = SCREENSIZE.width-28
        let navRect = self.navigationController?.navigationBar.frame
        menuView = CVCalendarMenuView(frame: CGRect(x:14, y:(navRect?.height)!+inset.top+16, width:WidthOfCalendar, height:15))
        calendarView = CVCalendarView(frame: CGRect(x:14, y:(navRect?.height)!+inset.top+16, width:WidthOfCalendar, height:WidthOfCalendar))
        calendarView.backgroundColor = UIColor.white
        calendarView.layer.cornerRadius = 8
        calendarView.layer.shadowColor = UIColor.black.cgColor
        calendarView.layer.shadowOffset = CGSize(width: 3, height: 6)
        //代理
        menuView.menuViewDelegate = self
        calendarView.calendarDelegate = self
        calendarView.calendarAppearanceDelegate = self
        //将菜单视图和日历视图添加到主视图上
        //self.view.addSubview(menuView)
        self.view.addSubview(calendarView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let panGestrue = scrollView.panGestureRecognizer
        let vol = panGestrue.velocity(in: self.view)
        //print(vol)
        if vol.y < -500 {
            self.calendarView.changeMode(.weekView)
            UIView.animate(withDuration: 0.5, animations: {
                let WidthOfCalendar = self.SCREENSIZE.width-28
                let navRect = self.navigationController?.navigationBar.frame
                self.calendarView.frame = CGRect(x:14, y:(navRect?.height)!+self.inset.top+16, width:WidthOfCalendar, height:60)
                
            })
        }else if vol.y > 500 {
            self.calendarView.changeMode(.monthView)
            UIView.animate(withDuration: 0.5, animations: {
                let WidthOfCalendar = self.SCREENSIZE.width-28
                let navRect = self.navigationController?.navigationBar.frame
                self.calendarView.frame = CGRect(x:14, y:(navRect?.height)!+self.inset.top+16, width:WidthOfCalendar, height:WidthOfCalendar)
            })
        }
        
    }
    
    
    func loadTopLineView() {
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(leftButton)
        topLineView.addSubview(rightButton)
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
        titleView.text = "我的时间轴"
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

    
    //MARK:calendar实现
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
//        //切换为周历
//        calendarView.changeMode(.weekView)
    }
    
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
        //print("selected")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    
}

