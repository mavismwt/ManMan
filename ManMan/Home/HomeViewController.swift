//
//  HomeViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/6.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit
import Alamofire
import SwiftyJSON

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage;
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width:self.size.width * scaleSize, height:self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}

extension UITabBar
{
    //关联对象的ID,注意，在私有嵌套 struct 中使用 static var，这样会生成我们所需的关联对象键，但不会污染整个命名空间。
    private struct AssociatedKeys {
        static var TabKey = "tabView"
    }
    
    //定义一个新的tabbar属性,并设置set,get方法
    var btnTab:UIButton?{
        get{
            //通过Key获取已存在的对象
            return objc_getAssociatedObject(self, &AssociatedKeys.TabKey) as? UIButton
        }
        set{
            //对象不存在则创建
            objc_setAssociatedObject(self, &AssociatedKeys.TabKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     添加中心按钮
     */
    func AddMyCenterTab()->UIButton
    {
        if self.btnTab == nil
        {
            self.shadowImage = UIImage()//(49 - 42) / 2
            let btn = UIButton(frame: CGRect.init(x: (UIScreen.main.bounds.size.width - 50) / 2, y: -14, width: 50, height: 50))
            btn.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            btn.setImage(UIImage.init(named: "add"), for: UIControl.State.normal)
            self.addSubview(btn)
            self.btnTab = btn
        }
        return self.btnTab!
    }
    
    
}


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    
    var topLineView = UIView()
    var calenderDetailButton = UIButton()
    var monthLabel = UILabel()
    var dayLabel = UILabel()
    var gotoFlag = UIButton()
    var addButton = UIButton()
    var img = UIImageView()
    
    let addView = AddView()
    let load = LoadView()
    var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), style: .grouped)
    let identifier = "reusedCell"
    var offset = CGFloat()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    var itemNameArray:[String] = ["homeUnselected","mineUnselected"]
    var itemNameSelectArray:[String] = ["homeSelected","mineSelected"]
    var itemTitle:[String] = ["日常","我的"]
    let imageName = ["fruit","word","drink","breakfast","makeup","sleep","read","sport","medicine"]
    let titleStr = ["吃水果","背单词","喝水","早餐","化妆","早睡","读书","运动","吃药"]
    var isVolumnOn = true
    
    var function = RequestFunction()
    
    struct taskDetail {
        var id: String?
        var name: String?
        var icon: String?
        var days: Int?
        var time: [Int64]?
        var isFinished: Bool?
    }
    
    var tasks = [taskDetail]()
    var request = RequestFunction()
    var flagID = String()
    var userInfo = UserInfo()
    var refreshTime = TimeInterval()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if let isOn:Int =  UserDefaults.standard.value(forKey: "isVolumnOn") as? Int {
            if isOn == 1 {
                self.isVolumnOn = true
            } else {
                self.isVolumnOn = false
            }
            UserDefaults.standard.set(nil, forKey: "isVolumnOn")
        }
        if let token = UserDefaults.standard.value(forKey: "token") {
            self.requestInfo(token: token as! String)
        }
    }
    
    func requestInfo(token: String) {
        let URLStr = "https://slow.hustonline.net/api/v1"
        let urlStr = "\(URLStr)/routine"
        let urlStr2 = "\(URLStr)/user"
        let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
        Alamofire.request(urlStr2, method: .get, headers: headers).responseJSON { response in
            self.tasks = [taskDetail]()
            self.tableView.removeAllSubviews()
            let json = JSON(response.result.value)
            if json["data"]["flags"].count != 0 {
                let num = json["data"]["flags"].count
                self.flagID = json["data"]["flags"][num-1]["id"].string!
                UserDefaults.standard.set(self.flagID, forKey: "myFlagID")
            }
            for k in 0..<json["data"]["routines"].count {
                var isFinished = false
                let routine = json["data"]["routines"][k]
                let dayCount = routine["sign_in"].count
                var time = [Int64]()
                if dayCount != 0 {
                    let lastSign = routine["sign_in"][dayCount-1].int64
                    let timeInterval:TimeInterval = TimeInterval(Int(lastSign!/1000))
                    let date = Date(timeIntervalSince1970: timeInterval)
                    isFinished = date.isToday()
                }
                for i in 0..<dayCount {
                    time.append(routine["sign_in"][i].int64!)
                }
                self.tasks.append(taskDetail.init(id: routine["id"].string, name:  routine["title"].string, icon:  routine["icon_id"].string, days: routine["sign_in"].count, time: time, isFinished: isFinished))
                
            }
            for i in 0..<json["data"]["records"].count {
                let record = json["data"]["records"][i]
                let time = record["time"].int64
                let ID = record["id"].string
                let content = record["content"].string
                let date = Date(timeIntervalSince1970: TimeInterval(time!/1000))
                if date.isToday() {
                    UserDefaults.standard.set(ID, forKey: "recordID")
                    UserDefaults.standard.set(content, forKey: "recordContent")
                }
            }
            let info = json["data"]
            let userInfo = UserInfo.init(id: info["id"].string, wxid: info["wx_id"].string, name: info["name"].string, imgURL: info["img_url"].string)
            let encoder = JSONEncoder()
            let data = try? encoder.encode(userInfo)
            UserDefaults.standard.set(data, forKey: "userInfo")
            self.tableView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let userinfo = UserDefaults.standard.value(forKey: "userInfo") {
            self.tabBarController?.view.addSubview(load)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute:
            {
                self.load.removeFromSuperview()
        })
        
        topLineView.addSubview(monthLabel)
        topLineView.addSubview(dayLabel)
        topLineView.addSubview(calenderDetailButton)
        
        self.view.addSubview(topLineView)
        //self.view.addSubview(gotoFlag)
        self.view.addSubview(tableView)
        
        let navRect = self.navigationController?.navigationBar.frame
        topLineView.frame = CGRect(x: 0, y: 0, width: (navRect?.width)!, height: (navRect?.height)!+inset.top)
        topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        calenderDetailButton.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(topLineView.snp.centerY).offset(inset.top/2)
            make.width.height.equalTo(24)
        }
        calenderDetailButton.setImage(UIImage(named: "calenderIcon"), for: .normal)
        calenderDetailButton.addTarget(self, action: #selector(goTo), for: .touchUpInside)
        
        monthLabel.snp.makeConstraints { (make) in
            make.right.equalTo(topLineView.snp.right).offset(-20)
            make.bottom.equalTo(calenderDetailButton.snp.bottom).offset(4)
            make.height.equalTo(22)
        }
        monthLabel.text = getNowDate()
        monthLabel.textColor = UIColor.white
        monthLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        tableView.frame =  CGRect(x: 0, y: inset.top+(navRect?.height)!, width: SCREENSIZE.width, height: SCREENSIZE.height-80-inset.top-inset.bottom)
        tableView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        self.configTabBar()
        addButton = (self.tabBarController?.tabBar.AddMyCenterTab())!
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        self.tabBarController?.tabBar.tintColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        self.tabBarController?.tabBar.shadowImage?.draw(in: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        
        self.initImg()
    }
    
    func initImg() {
        img = UIImageView(frame: CGRect(x: SCREENSIZE.width/2, y: SCREENSIZE.height/2, width: 140, height: 140))
        img.image = UIImage(named: "qian")
    }
    
    func localMusic()  {
        let path = Bundle.main.path(forResource: "check", ofType: "wav")
        //        public init(fileURLWithPath path: String)
        let soundUrl = URL(fileURLWithPath: path!)
        
        //在音频播放前首先创建一个异常捕捉语句
        do{
            //对音频播放对象进行初始化，并加载指定的音频播放对象
            //            public init(contentsOf url: URL) throws
            
            try audioPlayer = AVAudioPlayer(contentsOf:soundUrl)
            //设置音频对象播放的音量的大小
            audioPlayer.volume = 1.0
            //设置音频播放的次数，-1为无限循环播放
            audioPlayer.numberOfLoops = 0
            audioPlayer.play()
        }catch{
            print(error)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return tasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var flagCell:FlagCardCell? = tableView.dequeueReusableCell(withIdentifier: "flagCard") as? FlagCardCell
            if flagCell == nil {
                flagCell = FlagCardCell(style: .default, reuseIdentifier: "flagCard")
            }
            flagCell!.gotoFlag.addTarget(self, action: #selector(flag), for: .touchUpInside)
            return flagCell!
        }else{
            var cell:CheckCardCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? CheckCardCell
//            if (cell == nil)
//            {
                cell = CheckCardCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
                cell?.days = tasks[indexPath.row].days!
                cell?.taskName.text = tasks[indexPath.row].name
                cell?.taskIcon.image = UIImage(named: "\(tasks[indexPath.row].icon!)")
                cell?.isfinished = tasks[indexPath.row].isFinished!
               cell!.layoutSubviews()
//            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }else{
            return 95
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        offset = scrollView.contentOffset.y
    }
    
    //点击卡片动画
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell:CheckCardCell = tableView.cellForRow(at: indexPath) as! CheckCardCell
//        let tapGestureRecognizer = UITapGestureRecognizer()
//        tapGestureRecognizer.addTarget(self, action: #selector(check))
//        cell.cell.addGestureRecognizer(tapGestureRecognizer)
        cell.selectionStyle = .none
        self.img.frame = CGRect(x: cell.frame.width-110, y: cell.frame.maxY+8-offset, width: 150, height: 150)
        if cell.isfinished == false {
            
//            let queue = DispatchQueue(label: "thread", attributes: .concurrent)
//            queue.async {
//                time = self.request.postRoutineSign(id: self.tasks[indexPath.row].id!)
//                Thread.sleep(forTimeInterval: 0.5)
//                self.tasks[indexPath.row].time?.append(time)
//                print(time)
//                print(self.tasks[indexPath.row].time)
//            }
//            queue.async(flags: .barrier) {
//                print("1")
//            }
            var token = String()
            var time = Int64()
            if let str = UserDefaults.standard.value(forKey: "token") {
                token = str as! String
            }
            let routine = "{\"id\":\"\(self.tasks[indexPath.row].id!)\",\"time\":0,\"title\":\"\",\"icon_id\":\"\",\"sign_in\":[]}"
            let routineData = routine.data(using: String.Encoding.utf8)
            
            let urlStr = "https://slow.hustonline.net/api/v1/routine/sign"
            let url = URL(string: urlStr)!
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
            request.httpBody = routineData
            
            Alamofire.request(request).responseJSON { response in
                print("sign\(response)")
                let json = JSON(response.result.value)
                time = json["data"]["routines"][0]["time"].int64!
                print(time)
                self.tasks[indexPath.row].time?.append(time)
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                    cell.checkButton.removeFromSuperview()
                    self.view.addSubview(self.img)
                    self.img.frame = CGRect(x: (cell.frame.width-113)/382*(self.SCREENSIZE.width-32), y: cell.frame.maxY+4-self.offset, width: 120, height: 110)
                    self.img.layer.cornerRadius = 60
                }, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute:
                    {
                        self.img.removeFromSuperview()
                        cell.days += 1
                        cell.isfinished = true
                        cell.layoutSubviews()
                        if self.isVolumnOn == true {
                            self.localMusic()
                        }
                        
                })
            }
        } else {
            cell.days -= 1
            cell.isfinished = false
            let timeCount = self.tasks[indexPath.row].time?.count
            self.request.deleteRoutineSign(id: self.tasks[indexPath.row].id!, sign: self.tasks[indexPath.row].time!.last!)
            self.tasks[indexPath.row].time?.remove(at: timeCount!-1)
            cell.layoutSubviews()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    
    // 左滑按钮设置
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let detail = UITableViewRowAction(style: .normal, title: "编辑") {
            action, index in
            //UserDefaults.standard.set(self.tasks[indexPath.row].icon, forKey: "userDefinedTaskImage")
            //UserDefaults.standard.set(self.tasks[indexPath.row].name, forKey: "taskName")
            let addUserDefinedCheckViewController = AddUserDefinedCheckViewController()
            self.navigationController?.pushViewController(addUserDefinedCheckViewController, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        }
        detail.backgroundColor = UIColor.init(red: 120/255, green: 199/255, blue: 229/255, alpha: 1)
        
        let delete = UITableViewRowAction(style: .normal, title: "删除") {
            action, index in
            self.request.deleteRoutine(id: self.tasks[indexPath.row].id!)
            
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        delete.backgroundColor = UIColor.init(red: 241/255, green: 107/255, blue: 104/255, alpha: 1)
        
        return [delete,detail]
    }
    
    //alert
    func alertShow(title:String)
    {
        let alertView = UIAlertView(title: nil, message: title, delegate: nil, cancelButtonTitle: "确定")
    
        alertView.show()
    }
    

    //获取现在时间
    func getNowDate() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MMM d"
        let strNowMonth = timeFormatter.string(from: date) as String
        return strNowMonth
    }

    func configTabBar() {
        var count:Int = 0;
        let items = self.tabBarController?.tabBar.items
        for item in items as! [UITabBarItem] {
            let reSize = CGSize(width: 24, height: 24)
            var image:UIImage = UIImage(named: itemNameArray[count])!
            var selectedimage:UIImage = UIImage(named: itemNameSelectArray[count])!
            image = image.reSizeImage(reSize: reSize)
            image = image.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            selectedimage = selectedimage.reSizeImage(reSize: reSize)
            selectedimage = selectedimage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            item.selectedImage = selectedimage
            item.image = image
            item.title = itemTitle[count]
            count = count + 1
        }
        
    }
    @objc func add() {
        UIView.animate(withDuration: 0.5,animations: {
            self.tabBarController?.view.addSubview(self.addView)
            self.addView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.backToHome)))
            self.addView.isUserInteractionEnabled = true
            self.addView.addCheckButton.addTarget(self, action: #selector(self.addCheckTask), for: .touchUpInside)
            self.addView.addLogButton.addTarget(self, action: #selector(self.addLog), for: .touchUpInside)
            self.addView.addButton.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.addButton.snp.bottom)
            }
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,animations: {
            self.addView.addLogButton.center.y -= 16
            self.addView.addCheckButton.center.y -= 16
            self.addView.addButton.center.y -= 16
        }, completion: nil)
    }
    @objc func flag(){
        let flagViewController = FlagViewController()
        self.navigationController?.pushViewController(flagViewController, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    @objc func backToHome() {
        self.addView.removeFromSuperview()
    }
    @objc func addCheckTask() {
        let addCheckViewController = AddCheckViewController()
        self.navigationController?.pushViewController(addCheckViewController, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.addView.removeFromSuperview()
    }
    @objc func addLog() {
        let addLogViewController = AddLogViewController()
        self.navigationController?.pushViewController(addLogViewController, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.addView.removeFromSuperview()
    }
    @objc func goTo() {
        let logViewController = LogViewController()
        self.navigationController?.pushViewController(logViewController, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = true
    }
}

