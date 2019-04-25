//
//  StartViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/21.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShareViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var topLineView = UIView()
    var leftButton = UIButton()
    var rightButton = UIButton()
    var titleView = UILabel()
    
    var checkBt = UIButton()
    
    var imageView = UIView()
    var taskView = UIView()
    var nameView = UILabel()
    var tableView = UITableView()
    var logoView = UIView()
    var appLabel = UILabel()
    var appIcon = UIImageView()
    var alertView = AlertView()
    
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    let identifier = "reusedCell"
    let imageName = ["fruit","word","drink","breakfast","makeup","sleep","read","sport","medicine"]
    
    struct data {
        var title: String?
        var icon: String?
        var days: Int?
    }
    var datas = [data]()
    
    //var datas:[data] = [data.init(title: "喝水", icon: "drink")]
    
    override func viewDidLoad() {
        
        
        checkBt.frame = CGRect(x: 100, y: 500, width: 200, height: 100)
        checkBt.backgroundColor = UIColor.orange
        checkBt.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        self.loadTopLineView()
        self.setImageView()
        self.getData()
        //self.view.addSubview(checkBt)
        
    }
    
    func loadTopLineView() {
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"login")!)
        
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
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
        rightButton.setTitle("Save", for: .normal)
        //rightButton.setImage(UIImage(named: "download"), for: .normal)
        rightButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
    }
    
    func setImageView() {
        self.view.addSubview(imageView)
        imageView.backgroundColor = UIColor(patternImage: UIImage(named:"login")!)
        
        imageView.addSubview(taskView)
        imageView.addSubview(logoView)
        
        taskView.addSubview(nameView)
        taskView.addSubview(tableView)
        
        logoView.addSubview(appLabel)
        logoView.addSubview(appIcon)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom)
            make.left.equalTo(0)
            make.width.equalTo(SCREENSIZE.width)
            make.bottom.equalTo(-inset.bottom)
        }
        
        taskView.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-62)
        }
        taskView.backgroundColor = UIColor.white
        taskView.layer.cornerRadius = 8
        taskView.clipsToBounds = true
        taskView.layer.shadowOffset = CGSize(width: 3, height: 6)
        
        nameView.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.top.equalTo(32)
            make.height.equalTo(24)
        }
        nameView.text = "mavismwt"+"的"+"\(getNowDate())"
        nameView.textColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        nameView.font = UIFont.boldSystemFont(ofSize: 24)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom).offset(32)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(-16)
        }
        tableView.separatorStyle = .none
        tableView.register(ShareTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        
        logoView.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageView.snp.bottom).offset(-24)
            make.centerX.equalToSuperview()
            make.height.equalTo(26)
        }
        
        appIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(logoView.snp.centerX).offset(4)
            make.width.height.equalTo(26)
        }
        appIcon.image = UIImage(named: "AppIcon")
        
        appLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(logoView.snp.centerX).offset(-4)
            make.height.equalTo(16)
        }
        appLabel.text = "慢慢"
        appLabel.textColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        appLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        
    }
    
    func getData() {
        //,data.init(title: "早睡", icon: "sleep", isDate: false),data.init(title: "日志", icon: "log", isDate: false)]
        let URLStr = "https://slow.hustonline.net/api/v1"
        var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTY3NzU1MzYsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTU2MTcwNzM2fQ.WbTvev5bweV5OlhKRqypu5fdZmrZhBKHUpAji6N-6ng"
        let urlStr = "\(URLStr)/user"
        let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
        
        Alamofire.request(urlStr, method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                for i in 0..<json["data"]["routines"].count {
                    let routine = json["data"]["routines"][i]
                    for k in 0..<routine["sign_in"].count {
                        let lastSign = routine["sign_in"][k].int64
                        let timeInterval:TimeInterval = TimeInterval(Int(lastSign!/1000))
                        let signDate = Date(timeIntervalSince1970: timeInterval)
                        if signDate.isToday() {
                            self.datas.append(data.init(title: routine["title"].string, icon: routine["icon_id"].string, days: routine["sign_in"].count))
                        }
                    }
                }
            }
            self.tableView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
    
    func getNowDate() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "M月d日"
        let strNowMonth = timeFormatter.string(from: date) as String
        return strNowMonth
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:ShareTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? ShareTableViewCell
        if cell == nil {
            let cell:ShareTableViewCell = ShareTableViewCell.init(style: .default, reuseIdentifier: identifier) as! ShareTableViewCell
        }
        cell?.icon.image = UIImage(named: datas[indexPath.row].icon!)
        cell?.title.text = datas[indexPath.row].title
        cell?.days = datas[indexPath.row].days!
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //UIView转UIImage
    func getImageFromView(view:UIView) ->UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    //保存到本地
    func loadImage(image:UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
    {
        if didFinishSavingWithError != nil
        {
            print("error!")
            UIView.animate(withDuration: 0.5, animations: {
                    self.alertView.alertLabel.text = "保存失败"
                    self.alertView.imageView.image = UIImage(named: "fail")
                    self.view.addSubview(self.alertView)
            })
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:{
                self.alertView.removeFromSuperview()
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        print("保存成功")
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alertLabel.text = "保存成功"
            self.alertView.imageView.image = UIImage(named: "success")
            self.view.addSubview(self.alertView)
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:{
            self.alertView.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc func tap() {
        let check = getImageFromView(view: self.imageView)
        self.loadImage(image: check)
    }
    
}
