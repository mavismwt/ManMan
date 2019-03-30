//
//  FlagViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/5.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class FlagViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate {
    
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
    
    var topLineView = UIView()
    var backButton = UIButton()
    var titleView = UILabel()
    var letterButton = UIButton()
    
    //var commentView = CommentLineView()
    
    let coverView = UIView()
    let tableView = UITableView()
    
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    let identifier = "reusedCell"
    var HeightOfKeyboard:CGFloat? = 0
    var dTime:TimeInterval? = 0
    var flagDatas = [flagData]()
    
    var datas = ["1.跟朋友出去旅游一次\n2.周末在家做饭","回家胖五斤以内","学编程"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(backButton)
        topLineView.addSubview(titleView)
        topLineView.addSubview(letterButton)
        
        self.view.addSubview(topLineView)
        self.view.addSubview(tableView)
        //self.view.addSubview(commentView)
        
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
        //letterButton.setImage(UIImage(named: "editWhite"), for: .normal)
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
        
        self.sentAlert()
        
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:CustomizeUITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? CustomizeUITableViewCell
        cell?.selectionStyle = .none
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(comment))
        tapGestureRecognizer.delegate = self
        cell?.commentView.addGestureRecognizer(tapGestureRecognizer)
        if indexPath.row == 0 {
            let tag = UILabel()
            cell?.addSubview(tag)
            cell?.detail.text = datas[indexPath.row]
            if let myFlagDetail:String = UserDefaults.standard.value(forKey: "flagDetail") as? String {
                cell?.detail.text = myFlagDetail
                UserDefaults.standard.set(nil, forKey: "flagDetail")
            }
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
            }
        }else{
            cell?.detail.text = datas[indexPath.row]
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:CustomizeUITableViewCell = tableView.cellForRow(at: indexPath) as! CustomizeUITableViewCell
        UserDefaults.standard.set(cell.detail.text, forKey: "detail")
        
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
            print("点击了确定")
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func comment() {
        let flagDetailViewController = FlagDetailViewController()
        self.navigationController?.pushViewController(flagDetailViewController, animated: true)
    }
    
}
