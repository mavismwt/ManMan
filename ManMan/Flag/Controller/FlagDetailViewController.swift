//
//  FlagDetailViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/22.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class FlagDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    struct flagData {
        var profileURL = "UIImageView()"
        var nicknameText = "UILabel()"
        var detailText = "UITextView()"
//        var comment = [{
//            var userName = ""
//            var userComment = ""
//            }]
        var commentNumText = "UILabel()"
        var likeNumText = "UILabel()"
    }
    
    var str = ["好棒啊！","flag就是拿来倒的"]
    
    var topLineView = UIView()
    var backButton = UIButton()
    var titleView = UILabel()
    var detailView = FlagDetail()
    var commentView = CommentLineView()
    
    let coverView = UIView()
    let tableView = UITableView()
    
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    let identifier = "reusedCell"
    var HeightOfKeyboard:CGFloat? = 0
    var dTime:TimeInterval? = 0
    var height:[CGFloat] = [0,0,0]
    var flagDatas = [flagData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(backButton)
        topLineView.addSubview(titleView)
        
        detailView.addSubview(tableView)
        
        self.view.addSubview(topLineView)
        self.view.addSubview(detailView)
        self.view.addSubview(commentView)
        
        self.setTopLineView()
        self.setCommentLineView()
        
        detailView.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(commentView.snp.top).offset(-16)
        }
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(beginEdit))
        detailView.commentView.addGestureRecognizer(tapGestureRecognizer)
        if let detail:String = UserDefaults.standard.value(forKey: "detail") as? String {
            detailView.detail.text = detail
        }
        
        let navRect = self.navigationController?.navigationBar.frame
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(detailView.commentView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    func setTopLineView() {
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
    }
    
    func setCommentLineView() {
        commentView.inputText.delegate = self
        commentView.sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        commentView.inputText.returnKeyType = .send
        
        coverView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        coverView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.view.addSubview(coverView)
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(endEdit))
        tapGestureRecognizer.delegate = self
        coverView.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(note:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func comment() {
        self.commentView.inputText.becomeFirstResponder()
    }
    @objc func send() {
        //UIView.animate(withDuration: 0.3, animations: {
        self.commentView.inputText.resignFirstResponder()
        self.str.append(self.commentView.inputText.text!)
        self.height.append(0)
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.5, animations: {
            self.detailView.commentNumber = self.str.count
            self.detailView.layoutIfNeeded()
        })
        self.commentView.inputText.text = ""
        //})
        
    }
    @objc func beginEdit() {
        self.commentView.inputText.becomeFirstResponder()
    }
    @objc func endEdit() {
        self.commentView.inputText.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        //更新数据
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.addSubview(self.coverView)
        coverView.snp.makeConstraints { (make) in
            make.bottom.equalTo(commentView.snp.top)
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalToSuperview()
        }
        UIView.animate(withDuration: dTime!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: dTime!, animations: {
            self.coverView.removeFromSuperview()
        })
    }
    
    @objc func keyboardWillChangeFrame(note: Notification) {
        // 1.获取动画执行的时间
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 2.获取键盘最终 Y值
        dTime = duration
        let endFrame = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        HeightOfKeyboard = endFrame.origin.y
        //计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y
        print(margin)
        // 更新约束,执行动画
        commentView.snp.updateConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(60)
            make.bottom.equalTo(-margin)
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
        //self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func setMyFlag() {
        let addFlagViewController = AddFlagViewController()
        self.navigationController?.pushViewController(addFlagViewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return str.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:CommentTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? CommentTableViewCell
        cell?.selectionStyle = .none
        if (cell == nil)
        {
            let cell = CommentTableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell?.detail.text = str[indexPath.row]
        height[indexPath.row] = FlagDetail.heightForTextView(textView: (cell?.detail)!, fixedWidth: (cell?.detail.frame.width)!) + 32
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height[indexPath.row]
    }
    
    
    internal class func heightForTextView(textView: UITextView, fixedWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let constraint = textView.sizeThatFits(size)
        return constraint.height
    }
    
}

