//
//  try.swift
//  ManMan
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire
import SwiftyJSON

class LogViewController: UIViewController,UIScrollViewDelegate,CVCalendarViewDelegate,CVCalendarMenuViewDelegate,CVCalendarViewAppearanceDelegate {
    
    var topLineView = UIView()
    var leftButton = UIButton()
    var rightButton = UIButton()
    var titleView = UILabel()
    var monthView = UILabel()
    var cView = UIView()
    
    var scrollView = UIScrollView()
    var tableView = UITableView()
    var cell = LogCell()
    var showMoreView = ShowMoreView()

    private var menuView: CVCalendarMenuView!
    private var calendarView: CVCalendarView!
    
    var currentCalendar: Calendar!
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    
    struct data {
        var id: String?
        var title:String?
        var icon:String?
        var isDate:Bool?
    }
    var datas = [data]()
    var allDate = [Date]()
    var selDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        let date = getDateStr(date: Date())
//        datas = [data.init(title: date, icon: "", isDate: true)]//,data.init(title: "早睡", icon: "sleep", isDate: false),data.init(title: "日志", icon: "log", isDate: false)]
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        self.loadTopLineView()
        self.getData()
        self.setCalendarView()
        self.setScrollView()
    }
    
    
    func getData() {
        let dateStr = getDateStr(date: selDate)
        datas = [data.init(id: "0",title: dateStr, icon: "", isDate: true)]
        //,data.init(title: "早睡", icon: "sleep", isDate: false),data.init(title: "日志", icon: "log", isDate: false)]
        let URLStr = "https://slow.hustonline.net/api/v1"
        if let token = UserDefaults.standard.value(forKey: "token") { //"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTc0MTIwMDMsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTU2ODA3MjAzfQ.Bd25U4DIFoe0FrSvlqpWRLw0h6mG2to-ttNeV-Fk6nE"//UserDefaults.standard.value(forKey: "token")
            let urlStr = "\(URLStr)/user"
            let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
            
            Alamofire.request(urlStr, method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { response in
                self.allDate = [Date]()
                if let value = response.result.value {
                    let json = JSON(value)
                    for i in 0..<json["data"]["routines"].count {
                        let routine = json["data"]["routines"][i]
                        for k in 0..<routine["sign_in"].count {
                            let lastSign = routine["sign_in"][k].int64
                            let timeInterval:TimeInterval = TimeInterval(Int(lastSign!/1000))
                            let signDate = Date(timeIntervalSince1970: timeInterval)
                            self.allDate.append(signDate)
                            if signDate.isSameDay(day: self.selDate) {
                                self.datas.append(data.init(id: routine["id"].string, title: routine["title"].string, icon: routine["icon_id"].string, isDate: false))
                            }
                        }
                    }
                    for j in 0..<json["data"]["records"].count {
                        let record = json["data"]["records"][j]
                        let timeMili = record["time"].int64
                        let timeInterval:TimeInterval = TimeInterval(Int(timeMili!/1000))
                        let signDate = Date(timeIntervalSince1970: timeInterval)
                        self.allDate.append(signDate)
                        if signDate.isSameDay(day: self.selDate) {
                            self.datas.append(data.init(id: record["id"].string, title: "日志", icon: "log", isDate: false))
                        }
                    }
                }
                self.calendarView.layoutSubviews()
                self.calendarView.commitCalendarViewUpdate()
                self.calendarView.contentController.refreshPresentedMonth()
                self.setScrollViewData()
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
    func setScrollViewData() {
        self.scrollView.removeAllSubviews()
        for i in 0..<datas.count {
            if i == 0 {
                let cell = FirstLogCell.init(frame: CGRect(x: 0, y: 56*i, width: Int(SCREENSIZE.width), height: 56))
                cell.title.text = datas[i].title
                if datas.count == 1 {
                    cell.line.backgroundColor = UIColor.white
                }
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
            make.top.equalTo(cView.snp.bottom).offset(16)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let panGestrue = scrollView.panGestureRecognizer
        let vol = panGestrue.velocity(in: self.view)
        //print(vol)
        if vol.y < -1000 {
            self.calendarView.changeMode(.weekView)
            UIView.animate(withDuration: 0.6, animations: {
                let WidthOfCalendar = self.SCREENSIZE.width-28
                let navRect = self.navigationController?.navigationBar.frame
                //self.calendarView.frame = CGRect(x:0, y:(navRect?.height)!+self.inset.top+16, width:WidthOfCalendar, height:60)
                self.cView.frame = CGRect(x:14, y:(navRect?.height)!+self.inset.top+16, width:WidthOfCalendar, height:140)
                
            })
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseIn, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: -250)
            }, completion: nil)
            
        }else if vol.y > 1000 {
            self.calendarView.changeMode(.monthView)
            UIView.animate(withDuration: 0.6, animations: {
                let WidthOfCalendar = self.SCREENSIZE.width-28
                let navRect = self.navigationController?.navigationBar.frame
                //self.calendarView.frame = CGRect(x:0, y:(navRect?.height)!+self.inset.top+16, width:WidthOfCalendar, height:WidthOfCalendar)
                self.cView.frame = CGRect(x:14, y:(navRect?.height)!+self.inset.top+16, width:WidthOfCalendar, height:WidthOfCalendar)
                
            })
            UIView.animate(withDuration: 0.3, delay: 0.4, options: .curveLinear, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }, completion: nil)
        }
        print(self.scrollView.contentOffset.y)
        
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
        
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.right.equalTo(-16)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        rightButton.setImage(UIImage(named: "more"), for: .normal)
        rightButton.addTarget(self, action: #selector(showMore), for: .touchUpInside)
        
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func showMore() {
        let navRect = self.navigationController?.navigationBar.frame
        showMoreView = ShowMoreView.init(frame: CGRect(x: 0, y: (navRect?.height)!+inset.top, width: SCREENSIZE.width, height: SCREENSIZE.height-(navRect?.height)!+inset.top-inset.bottom))
        self.view.addSubview(showMoreView)
        showMoreView.detail.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        showMoreView.share.addTarget(self, action: #selector(shareView), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(cancel))
        showMoreView.self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func showDetail() {
        let logDetailViewController = LogDetailViewController()
        self.navigationController?.pushViewController(logDetailViewController, animated: true)
        showMoreView.removeFromSuperview()
    }
    
    @objc func shareView() {
        let shareViewController = ShareViewController()
        self.navigationController?.pushViewController(shareViewController, animated: true)
        showMoreView.removeFromSuperview()
    }
    
    @objc func cancel() {
        showMoreView.removeFromSuperview()
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
    
    func getDateStr(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MMM.d"
        let str = timeFormatter.string(from: date) as String
        return str
    }
    
    func getNowMonth() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MMMM"
        let strNowMonth = timeFormatter.string(from: date) as String
        return strNowMonth
    }
    
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
        self.datas[0].title = "\(month) \(date.day)"
        self.selDate = date.convertedDate()!
        self.tableView.reloadData()
        self.view.layoutIfNeeded()
        self.getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    
}

