//
//  FlagViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/5.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire
import SwiftyJSON

class FlagViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate {
    

    
    var topLineView = UIView()
    var backButton = UIButton()
    var titleView = UILabel()
    var letterButton = UIButton()
    
    let coverView = UIView()
    let tableView = UITableView()
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    let identifier = "reusedCell"
    var HeightOfKeyboard:CGFloat? = 0
    var dTime:TimeInterval? = 0
    var flagDatas = [FlagData]()
    
    var MyID = ""
    var index = 0
    var selectedCellId = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let ID = UserDefaults.standard.value(forKey: "userID") {
            MyID = ID as! String
        }
        
        let URLStr = "https://slow.hustonline.net/api/v1"
        var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTUyNDc1NzMsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTU0NjQyNzczfQ.m6i6TH7mK34cA0oc6P9Dc_xKxQWwOoch8VdgGPrwt2k"
        let urlStr = "\(URLStr)/flag/flags"
        let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
        Alamofire.request(urlStr, method: .get, parameters: ["num": index], encoding: URLEncoding.default,headers: headers).responseJSON { response in
            //print(response)
            let json = JSON(response.result.value)
            for k in 0..<json["data"]["flags"].count {
                let value = json["data"]["flags"][k]
                var comments = [CommentDetail]()
                for i in 0..<value["flags"]["comments"].count {
                    comments.append(CommentDetail.init(userName: value["flag"]["comments"][i]["name"].string, userComment: value["flag"]["comments"][i]["content"].string))
                }
                self.flagDatas.append(FlagData.init(userId: value["wx_id"].string, profileURL: value["img_url"].string, nickname: value["name"].string, time: value["flags"]["time"].int64, detail: value["flags"]["content"].string, comment: comments, commentNum: value["flags"]["comments"].count, likeNum: value["flags"]["likes"].count, id: value["flags"]["id"].string))
                
                self.tableView.reloadData()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        tableView.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableView.mj_footer = footer
        
        self.setView()
        self.sentAlert()
        
    }
    
    func setView() {
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(backButton)
        topLineView.addSubview(titleView)
        topLineView.addSubview(letterButton)
        
        self.view.addSubview(topLineView)
        self.view.addSubview(tableView)
        
        let navRect = self.navigationController?.navigationBar.frame
        topLineView.frame = CGRect(x: 0, y: 0, width: (navRect?.width)!, height: (navRect?.height)!+inset.top)
        topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        titleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        titleView.text = "FLAG"
        titleView.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        titleView.font = UIFont.boldSystemFont(ofSize: 18)
        
        backButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.left.equalTo(16)
            make.width.equalTo(15)
            make.height.equalTo(20)
        }
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        letterButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.right.equalTo(-16)
            make.height.equalTo(20)
        }
        letterButton.setTitle("Edit", for: .normal)
        letterButton.addTarget(self, action: #selector(setMyFlag), for: .touchUpInside)
        
        tableView.frame = CGRect(x: 0, y: (navRect?.height)!+inset.top+8, width: SCREENSIZE.width, height: SCREENSIZE.height-8-(navRect?.height)!-inset.top-inset.bottom)
        tableView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(CustomizeUITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        coverView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        coverView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.view.addSubview(coverView)
    }
    
    // 顶部刷新
    @objc func headerRefresh(){
        // 结束刷新
        self.tableView.mj_header.endRefreshing()
    }
    
    // 底部刷新
    @objc func footerRefresh(){
        self.tableView.mj_footer.endRefreshing()
        // 2次后模拟没有更多数据
        index = index + 1
        if index > 2 {
            footer.endRefreshingWithNoMoreData()
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func setMyFlag() {
        let addFlagViewController = AddFlagViewController()
        self.navigationController?.pushViewController(addFlagViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:CustomizeUITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? CustomizeUITableViewCell
        cell?.selectionStyle = .none
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(comment))
        tapGestureRecognizer.delegate = self
        cell?.commentView.addGestureRecognizer(tapGestureRecognizer)
        
        if flagDatas[indexPath.row].userId == MyID {
            print(indexPath.row,flagDatas[indexPath.row].userId,MyID)
            let tag = UILabel()
            tag.text = "我"
            tag.font = UIFont.systemFont(ofSize: 12)
            tag.textAlignment = .center
            tag.textColor = UIColor.white
            tag.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
            tag.layer.cornerRadius = 2
            tag.clipsToBounds = true
            tag.snp.makeConstraints { (make) in
                make.centerY.equalTo((cell?.nickname.snp.centerY)!)
                make.left.equalTo((cell?.nickname.snp.right)!).offset(8)
                make.width.height.equalTo(14)
            cell?.addSubview(tag)
            }
        }
        cell?.id = flagDatas[indexPath.row].id!
        cell?.userid = flagDatas[indexPath.row].userId!
        cell?.detail.text = flagDatas[indexPath.row].detail
        Alamofire.request(flagDatas[indexPath.row].profileURL!).responseData { response in
            guard let data = response.result.value else { return }
            let image = UIImage(data: data)
            cell?.profile.image = image
        }
        cell?.nickname.text = flagDatas[indexPath.row].nickname
        let timeInterval = flagDatas[indexPath.row].time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval!/1000))
        let timeStr = timeFormatter.string(from: date)
        cell?.time.text = timeStr
        cell?.likeNumber = flagDatas[indexPath.row].likeNum!
        cell?.commentNumber = flagDatas[indexPath.row].commentNum!
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:CustomizeUITableViewCell = tableView.cellForRow(at: indexPath) as! CustomizeUITableViewCell
        let flagDetailViewController = FlagDetailViewController()
        let id = cell.id
        var detail = FlagData()
        for i in 0..<flagDatas.count {
            if flagDatas[i].id == id {
                detail = flagDatas[i]
            }
        }
        let encoder = JSONEncoder()
        let data = try? encoder.encode(detail)
        UserDefaults.standard.set(data, forKey: "flagData")
        self.navigationController?.pushViewController(flagDetailViewController, animated: true)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    
    func sentAlert() {
        let alert = UIAlertController(title: "注意", message: "Flag功能仅在每月1-2号开放", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            //点击事件
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func comment() {
        
        //let flagDetailViewController = FlagDetailViewController()
        //self.navigationController?.pushViewController(flagDetailViewController, animated: true)
    }
    
}
