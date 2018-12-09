//
//  MineViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/6.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class MineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var topLineView = UIView()
    var profileView = UIImageView()
    var nickname = UITextField()
    var editButton = UIButton()
    var tableView = UITableView()
    
    let SCREENSIZE = UIScreen.main.bounds.size
    let listDetail:[String] = ["我的flag","我的时间轴","设置","问题反馈"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(profileView)
        topLineView.addSubview(nickname)
        topLineView.addSubview(editButton)
        
        self.view.addSubview(topLineView)
        self.view.addSubview(tableView)
        
        topLineView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(SCREENSIZE.width)
            make.height.equalTo(183)
        }
        topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        profileView.snp.makeConstraints { (make) in
            make.top.equalTo(43)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(72)
        }
        profileView.image = UIImage(named: "MyProfile")
        profileView.layer.cornerRadius = 36
        profileView.clipsToBounds = true
        
        nickname.snp.makeConstraints { (make) in
            make.top.equalTo(profileView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        nickname.text = "mavismwt"
        nickname.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        nickname.font = UIFont.boldSystemFont(ofSize: 18)
        
        editButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(nickname.snp.centerY)
            make.left.equalTo(nickname.snp.right).offset(8)
            make.width.height.equalTo(15)
        }
        let editImg = UIImage(named: "editWhite")
        editButton.setImage(editImg, for: UIControl.State.normal)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(191)
            make.width.equalTo(SCREENSIZE.width)
            make.height.equalTo(SCREENSIZE.height-233)
        }
        tableView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "reusedCell"
        var cell:ListTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? ListTableViewCell
        if (cell == nil)
        {
            cell = ListTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
            cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            let item = listDetail[indexPath.row]
            cell?.title.text = item
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listStr = listDetail[indexPath.row]
        
        //,,"设置","问题反馈"
        switch listStr {
        case "我的flag":
            let flagViewController = FlagViewController()
            self.navigationController?.pushViewController(flagViewController, animated: true)
        case "我的时间轴":
            let logViewController = LogViewController()
            self.navigationController?.pushViewController(logViewController, animated: true)
        default:
            break
        }
    }
    
}
