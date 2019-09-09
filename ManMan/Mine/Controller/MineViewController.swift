//
//  MineViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/6.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
import SwiftyJSON

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}


class MineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate {
    
    var topLineView = UIView()
    var profileView = UIImageView()
    var nickname = UITextField()
    var editButton = UIButton()
    var tableView = UITableView()
    var coverView = UIView()
    var endEditView = UIView()
    
    
    let function = RequestFunction()
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    let identifier = "reusedCell"
    let listDetail:[String] = ["我的flag","我的时间轴","设置","问题反馈"]
    var userInfo = UserInfo()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        if let isVisitor = UserDefaults.standard.value(forKey: "visitor") {
            self.showUserInfo(name: "点击登录", imgURL: "default")
        } else {
            if let data = UserDefaults.standard.value(forKey: "userInfo") {
                let decoder = JSONDecoder()
                let obj = try? decoder.decode(UserInfo.self, from: data as! Data)
                userInfo = obj!
                self.showUserInfo(name: userInfo.name!, imgURL: userInfo.imgURL!)
            }
        }
    }
    
    func showUserInfo(name: String, imgURL: String) {
        function.getUserInfo()
        topLineView.addSubview(profileView)
        topLineView.addSubview(nickname)
        //topLineView.addSubview(editButton)
        
        self.view.addSubview(topLineView)
        self.view.addSubview(tableView)
        
        topLineView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(SCREENSIZE.width)
            make.height.equalTo(178)
        }
        topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        profileView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-55)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(72)
        }
        if imgURL == "default" || imgURL == nil {
            profileView.image = UIImage(named: "MyProfile")
        } else {
            Alamofire.request(imgURL).responseData { response in
                guard let data = response.result.value else { return }
                let image = UIImage(data: data)
                self.profileView.image = image
            }
        }
        profileView.layer.cornerRadius = 36
        profileView.clipsToBounds = true
//        let TapGestureRecognizer = UITapGestureRecognizer()
//        TapGestureRecognizer.addTarget(self, action: #selector(login))
//        profileView.addGestureRecognizer(TapGestureRecognizer)
        
        nickname.snp.makeConstraints { (make) in
            make.top.equalTo(profileView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        nickname.text = name
        nickname.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        nickname.font = UIFont.boldSystemFont(ofSize: 18)
        nickname.returnKeyType = .done
        nickname.delegate = self
        nickname.isUserInteractionEnabled = false
        
//        editButton.snp.makeConstraints { (make) in
//            make.centerY.equalTo(nickname.snp.centerY)
//            make.left.equalTo(nickname.snp.right).offset(8)
//            make.width.height.equalTo(15)
//        }
//        let editImg = UIImage(named: "editWhite")
//        editButton.setImage(editImg, for: UIControl.State.normal)
//        editButton.addTarget(self, action: #selector(changeEditStatus), for: .touchUpInside)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(191)
            make.width.equalTo(SCREENSIZE.width)
            make.height.equalTo(SCREENSIZE.height-233)
        }
        tableView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ListTableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
        
        let bt = self.tabBarController?.tabBar.AddMyCenterTab()
        coverView = UIView(frame: (bt?.frame)!)
        coverView.layer.cornerRadius = 25
        coverView.clipsToBounds = true
        coverView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(done))
        endEditView.frame = self.view.frame
        endEditView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0)
        endEditView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func login() {
        let loginViewController = LoginViewController()
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func changeEditStatus() {
        nickname.becomeFirstResponder()
    }
    
    @objc func done() {
        nickname.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        //更新数据
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.addSubview(endEditView)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        endEditView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ListTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? ListTableViewCell
        let item = listDetail[indexPath.row]
        cell?.selectionStyle = .none
        cell?.title.text = item
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:ListTableViewCell = tableView.cellForRow(at: indexPath) as! ListTableViewCell
        let listStr = listDetail[indexPath.row]
        switch listStr {
        case "我的flag":
            let flagViewController = FlagDetailViewController()
            self.navigationController?.pushViewController(flagViewController, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        case "我的时间轴":
            let logViewController = LogViewController()
            self.navigationController?.pushViewController(logViewController, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        case "设置":
            let settingViewController = SettingViewController()
            self.navigationController?.pushViewController(settingViewController, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        case "问题反馈":
            self.sendEmail()
//            let feedbackViewController = FeedbackViewController()
//            self.navigationController?.pushViewController(feedbackViewController, animated: true)
//            self.tabBarController?.tabBar.isHidden = true
        default:
            break
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        //设置邮件地址、主题及正文
        mailComposeVC.setToRecipients(["mavismwt@bingyan.net","songzilan@foxmail.com"])
        mailComposeVC.setSubject("问题反馈")
        //mailComposeVC.setMessageBody("<邮件正文>", isHTML: false)
        
        //获取设备名称
        let deviceName = UIDevice.current.name
        //获取系统版本号
        let systemVersion = UIDevice.current.systemVersion
        //获取设备的型号
        let deviceModel = UIDevice.current.model
        //获取设备唯一标识符
        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
        
        let infoDic = Bundle.main.infoDictionary
        // 获取App的版本号
        let appVersion = infoDic?["CFBundleShortVersionString"]
        // 获取App的build版本
        let appBuildVersion = infoDic?["CFBundleVersion"]
        // 获取App的名称
        let appName = infoDic?["CFBundleDisplayName"]
        //调用
        let modelName = UIDevice.current.modelName
        mailComposeVC.setMessageBody("\n\n\n\n\n\n应用名称：\(appName!)\n应用版本：\(appVersion!)\n系统版本：\(systemVersion)\n设备型号：\(modelName)", isHTML: false)
        
        return mailComposeVC
        
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "无法发送邮件", message: "您的设备尚未设置邮箱，请在“邮件”应用中设置后再尝试发送。", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "确定", style: .default) { _ in })
        self.present(sendMailErrorAlert, animated: true){}
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("取消发送")
        case MFMailComposeResult.sent.rawValue:
            print("发送成功")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            //注意这个实例要写在if block里，否则无法发送邮件时会出现两次提示弹窗（一次是系统的）
            let mailComposeViewController = configuredMailComposeViewController()
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.addSubview(coverView)
        self.tabBarController?.tabBar.isHidden = false
        //function.getUserInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        coverView.removeFromSuperview()
        //self.tabBarController?.tabBar.isHidden = true
    }
    
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

