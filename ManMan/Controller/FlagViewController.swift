//
//  FlagViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/5.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class FlagViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    struct flagData {
        var profileURL = "UIImageView()"
        var nicknameText = "UILabel()"
        var detailText = "UITextView()"
        var comment = [{
            var userName = ""
            var userComment = ""
            }]
        var commentNumText = "UILabel()"
        var likeNumText = "UILabel()"
    }
    
    var flagDatas = [flagData]()
    
    let SCREENRECT = UIScreen.main.nativeBounds
    
    let tableView = UITableView()
    let identifier = "reusedCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.title = "Flag"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.add, target: self, action: #selector(check))
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        

        self.view.addSubview(tableView)
        

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(70)
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
        }
        tableView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        tableView.separatorStyle = .none
        
        tableView.register(CustomizeUITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    
    @objc func check(){
        print("checked")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:CustomizeUITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? CustomizeUITableViewCell
        if (cell == nil)
        {
        }
        //self.viewDidDisappear(true)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 183
    }
    
}
