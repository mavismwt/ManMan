//
//  SettingViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var topLineView = UIView()
    var leftButton = UIButton()
    var titleView = UILabel()
    
    var tableView = UITableView()
    
    let identifier = "reusedCell"
    let SCREENSIZE = UIScreen.main.bounds.size
    let listDetail:[String] = ["打卡声音","晚安提示","加入系统日历"]
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(leftButton)
        topLineView.addSubview(titleView)
        
        self.view.addSubview(topLineView)
        self.view.addSubview(tableView)
        
        topLineView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(SCREENSIZE.width)
            make.height.equalTo(70)
        }
        topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        titleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        titleView.text = "设置"
        titleView.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        titleView.font = UIFont.boldSystemFont(ofSize: 18)
        
        leftButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(10)
            make.left.equalTo(16)
            make.width.equalTo(15)
            make.height.equalTo(20)
        }
        leftButton.setImage(UIImage(named: "back"), for: .normal)
        leftButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        tableView.frame = CGRect(x: 0, y: 86, width: SCREENSIZE.width, height: SCREENSIZE.height-86)
        tableView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        tableView.register(SettingTableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:SettingTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingTableViewCell
        cell?.title.text = listDetail[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
