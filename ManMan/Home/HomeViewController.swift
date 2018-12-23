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


class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    //初始化音频播放对象
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
    let tableView = UITableView()
    let identifier = "reusedCell"
    
    let SCREENSIZE = UIScreen.main.bounds.size
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    var itemNameArray:[String] = ["homeUnselected","mineUnselected"]
    var itemNameSelectArray:[String] = ["homeSelected","mineSelected"]
    var itemTitle:[String] = ["日常","我的"]
    let imageName = ["fruit","word","drink","breakfast","makeup","sleep","read","sport","medicine"]
    let titleStr = ["吃水果","背单词","喝水","早餐","化妆","早睡","读书","运动","吃药"]
    var isVolumnOn = true
    
    struct taskDetail {
        var name:String?
        var icon:String?
        var day:Int?
        var isfinished:Bool?
    }
    
    var tasks = [taskDetail]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        print("ok")
        if let taskNumber:Int = UserDefaults.standard.value(forKey: "taskNumber") as? Int {
            print(taskNumber)
            tasks.append(taskDetail.init(name: titleStr[taskNumber], icon: imageName[taskNumber], day: 0, isfinished: false))
            self.tableView.reloadData()
            UserDefaults.standard.set(nil, forKey: "taskNumber")
        }
        if let userDefinedTaskNumber:Int = UserDefaults.standard.value(forKey: "userDefinedTaskNumber") as? Int {
            let userDefinedTaskName:String =
                UserDefaults.standard.value(forKey: "taskName") as! String
            tasks.append(taskDetail.init(name: userDefinedTaskName, icon: imageName[userDefinedTaskNumber], day: 0, isfinished: false))
            self.tableView.reloadData()
            UserDefaults.standard.set(nil, forKey: "taskName")
            UserDefaults.standard.set(nil, forKey: "userDefinedTaskNumber")
        }
        if let isOn:Bool =  UserDefaults.standard.value(forKey: "isVolumnOn") as? Bool {
            self.isVolumnOn = isOn
            UserDefaults.standard.set(nil, forKey: "isVolumnOn")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.view.addSubview(load)
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute:
            {
                self.load.removeFromSuperview()
        })
        
        topLineView.addSubview(monthLabel)
        topLineView.addSubview(dayLabel)
        topLineView.addSubview(calenderDetailButton)
        
        self.view.addSubview(topLineView)
        self.view.addSubview(gotoFlag)
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
            make.bottom.equalTo(calenderDetailButton.snp.bottom)
            make.height.equalTo(18)
        }
        monthLabel.text = getNowDate()
        monthLabel.textColor = UIColor.white
        monthLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        gotoFlag.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(self.view.snp.right).offset(-16)
            make.height.equalTo(50)
        }
        gotoFlag.layer.cornerRadius = 8
        gotoFlag.clipsToBounds = true
        gotoFlag.backgroundColor = UIColor.white
        gotoFlag.setTitle("设定你的本月FLAG吧！", for: .normal)
        gotoFlag.setTitleColor(UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1), for: .normal)
        gotoFlag.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        gotoFlag.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        gotoFlag.addTarget(self, action: #selector(flag), for: .touchUpInside)
        
        tableView.frame = CGRect(x: 0, y: inset.top+(navRect?.height)!+70, width: SCREENSIZE.width, height: SCREENSIZE.height-166-inset.top-inset.bottom)
        print(self.view.safeAreaInsets)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:CheckCardCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? CheckCardCell
        if (cell == nil)
        {
            cell = CheckCardCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
            cell?.taskName.text = tasks[indexPath.row].name
            cell?.taskIcon.image = UIImage(named: tasks[indexPath.row].icon!)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    //songshlan@bingyn.net
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:CheckCardCell = tableView.cellForRow(at: indexPath) as! CheckCardCell
//        let tapGestureRecognizer = UITapGestureRecognizer()
//        tapGestureRecognizer.addTarget(self, action: #selector(check))
//        cell.cell.addGestureRecognizer(tapGestureRecognizer)
        cell.selectionStyle = .none
        self.img.frame = CGRect(x: cell.frame.width-115, y: cell.frame.maxY+50, width: 150, height: 150)
        if cell.isfinished == false {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                cell.checkButton.removeFromSuperview()
                self.view.addSubview(self.img)
                self.img.frame = CGRect(x: cell.frame.width-115, y: cell.frame.maxY+50, width: 110, height: 110)
                self.img.layer.cornerRadius = 60
            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute:
                {
//                    cell.background.removeFromSuperview()
//                    cell.checkButton.removeFromSuperview()
                    cell.days += 1
                    cell.isfinished = true
                    cell.reSetTableViewCell()
                    self.img.removeFromSuperview()
                    //self.initImg()
                    if self.isVolumnOn == true {
                        self.localMusic()
                    }
            })
            cell.isfinished = true
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 左滑按钮设置
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let detail = UITableViewRowAction(style: .normal, title: "编辑") {
            action, index in
            print("favorite button tapped")
            UserDefaults.standard.set(self.tasks[indexPath.row].icon, forKey: "userDefinedTaskImage")
            UserDefaults.standard.set(self.tasks[indexPath.row].name, forKey: "taskName")
            let addUserDefinedCheckViewController = AddUserDefinedCheckViewController()
            self.navigationController?.pushViewController(addUserDefinedCheckViewController, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        }
        detail.backgroundColor = UIColor.init(red: 120/255, green: 199/255, blue: 229/255, alpha: 1)
        
        let delete = UITableViewRowAction(style: .normal, title: "删除") {
            action, index in
            print("share button tapped")
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        delete.backgroundColor = UIColor.init(red: 241/255, green: 107/255, blue: 104/255, alpha: 1)
        
        return [delete,detail]
    }
    
    // MARK: - alert
    
    func alertShow(title:String)
    {
        let alertView = UIAlertView(title: nil, message: title, delegate: nil, cancelButtonTitle: "确定")
    
        alertView.show()
    }
    

    
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
