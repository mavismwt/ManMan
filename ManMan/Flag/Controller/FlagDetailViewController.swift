//
//  FlagDetailViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/22.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FlagDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate {
    
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
    var dTime: TimeInterval? = 0
    var height:[CGFloat] = [0,0,0]
    var detail:FlagData?
    var request = RequestFunction()
    var nickname: String?
    var profileURl: String?
    
    override func viewWillAppear(_ animated: Bool) {
        if let nickname = UserDefaults.standard.value(forKey: "nickname"), let profileURL = UserDefaults.standard.value(forKey: "profileURL") {
            self.nickname = nickname as! String
            self.profileURl = profileURL as! String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(backButton)
        topLineView.addSubview(titleView)
        
        self.view.addSubview(topLineView)
        
        detailView.addSubview(tableView)
        self.view.addSubview(detailView)
        self.view.addSubview(commentView)
        
        self.setTopLineView()
        
        var textView = UITextView()
        if let data = UserDefaults.standard.value(forKey: "flagData") {
            let decoder = JSONDecoder()
            let obj = try? decoder.decode(FlagData.self, from: data as! Data)
            detail = obj
            if detail?.comment.count == 0 {
                tableView.backgroundColor = UIColor.white
                textView = UITextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-64, height: 100))
                textView.text = "此处还没有评论"
                textView.font = UIFont.systemFont(ofSize: 16)
                textView.textColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
                textView.textAlignment = .center
                tableView.addSubview(textView)
            }else{
                tableView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
                textView.removeFromSuperview()
            }
            self.setDetailView()
            self.setCommentLineView()
            self.view.layoutIfNeeded()
            UserDefaults.standard.set(nil, forKey: "flagData")
        } else if let userId = UserDefaults.standard.value(forKey: "userID") {
            let URLStr = "https://slow.hustonline.net/api/v1"
            var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTYxNTcyODEsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTU1NTUyNDgxfQ.UB5ASV9pM4SO1WP1le1ZyLQtlOjzcOtl8tq3gyOW1rU"
            let urlStr = "\(URLStr)/flag"
            let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
            Alamofire.request(urlStr, method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { response in
                print(response)
                let json = JSON(response.result.value)
                let num = json["data"]["flags"].count
                let value = json["data"]["flags"][num-1]
                var comDetails = [CommentDetail]()
                if value["comments"].count != 0 {
                    for i in 0..<value["comments"].count {
                        let comDetail = CommentDetail.init(userName: value["comments"][i]["from_id"].string, userComment: value["comments"][i]["content"].string)
                        comDetails.append(comDetail)
                    }
                    self.detailView.addSubview(self.tableView)
                }
                var isLiked = false
                let likeNum = value["flags"]["likes"].count
                if likeNum != 0 {
                    let likeSign = value["flags"]["likes"][likeNum - 1].int64
                    let date = Date(timeIntervalSince1970: (TimeInterval(likeSign!/1000)))
                    isLiked = date.isToday()
                }
                self.detail = FlagData(userId: value["id"].string, profileURL: self.profileURl, nickname: self.nickname, time: value["time"].int64, detail: value["content"].string, comment: comDetails, commentNum: value["comments"].count,isLiked: isLiked, likeNum: value["likes"].count, id: value["id"].string)
                print(self.detail)
                self.setDetailView()
                self.setCommentLineView()
                self.view.layoutIfNeeded()
                
            }
            
        }
        
        
        
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
    
    func setDetailView() {
        detailView.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(commentView.snp.top).offset(-16)
        }
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(beginEdit))
        detailView.commentView.addGestureRecognizer(tapGestureRecognizer)
        if let detail:String = self.detail?.detail {
            detailView.detail.text = detail
        }
        detailView.detail.text = detail?.detail
        detailView.nickname.text = detail?.nickname
        if let timeInterval = detail?.time {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyy年MM月dd日 HH:mm"
            let date = Date(timeIntervalSince1970: TimeInterval(timeInterval/1000))
            let timeStr = timeFormatter.string(from: date)
            detailView.time.text = timeStr
        }
        if let cNum:Int = detail?.commentNum, let lNum:Int = detail?.likeNum {
            detailView.commentNumber = cNum
            detailView.likeNumber = lNum
        }
        detailView.isliked = detail!.isLiked!
        
        Alamofire.request((detail?.profileURL!)!).responseData { response in
            guard let data = response.result.value else { return }
            let image = UIImage(data: data)
            self.detailView.profile.image = image
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
        //tableView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
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
    //发送评论
    @objc func send() {
        if self.commentView.inputText.text != nil {
            self.request.postFlagComment(openid: self.detail!.userId!, flagid: self.detail!.id!, comment: self.commentView.inputText.text!)
            let comment = CommentDetail.init(userName: self.detail!.userId!, userComment: self.commentView.inputText.text!)
            self.detail?.comment.append(comment)
            self.commentView.inputText.resignFirstResponder()
            self.detailView.commentNumber = (detail?.comment.count)!
            print(detail?.comment.count)
            self.detailView.layoutSubviews()
            self.tableView.reloadData()
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                self.detailView.layoutIfNeeded()
                
            })
            self.commentView.inputText.text = ""
        }
        
        
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
        // 更新约束,执行动画
        if margin != 0.0 {
            commentView.snp.updateConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(60)
                make.bottom.equalTo(-margin)
            }
        }else{
            commentView.snp.updateConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(60)
                make.bottom.equalTo(-inset.bottom)
            }
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
        let flagViewcontroller = FlagViewController()
        //flagViewcontroller.viewWillAppear(true)
    }
    
    @objc func setMyFlag() {
        let addFlagViewController = AddFlagViewController()
        self.navigationController?.pushViewController(addFlagViewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.detail?.comment.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:CommentTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? CommentTableViewCell
        cell?.selectionStyle = .none
        if (cell == nil)
        {
            let cell = CommentTableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell?.nickname.text = self.detail?.comment[indexPath.row].userName
        cell?.detail.text = self.detail?.comment[indexPath.row].userComment
        //height[indexPath.row] = FlagDetail.heightForTextView(textView: (cell?.detail)!, fixedWidth: (cell?.detail.frame.width)!) + 32
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return height[indexPath.row]
        return 80
    }
    
    
    internal class func heightForTextView(textView: UITextView, fixedWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let constraint = textView.sizeThatFits(size)
        return constraint.height
    }
    
}

