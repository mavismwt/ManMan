//
//  FeedbackViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import MessageUI

class FeedbackViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate {
    
    var topLineView = UIView()
    var leftButton = UIButton()
    var rightButton = UIButton()
    var titleView = UILabel()
    var firstSubTitle = UILabel()
    var textView = UIView()
    var inputText = UITextView()
    var secondSubTitle = UILabel()
    var secondTextView = UIView()
    var secondInputText = UITextField()
    var textLabel = UILabel()
    var confirmButton = UIButton()
    let endEditView = UIView()
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(leftButton)
        topLineView.addSubview(titleView)
        textView.addSubview(inputText)
        secondTextView.addSubview(secondInputText)
        
        self.view.addSubview(firstSubTitle)
        self.view.addSubview(secondSubTitle)
        self.view.addSubview(textView)
        self.view.addSubview(secondTextView)
        self.view.addSubview(textLabel)
        self.view.addSubview(confirmButton)
        self.view.addSubview(topLineView)
        
        let navRect = self.navigationController?.navigationBar.frame
        topLineView.frame = CGRect(x: 0, y: 0, width: (navRect?.width)!, height: (navRect?.height)!+inset.top)
        topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        titleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        titleView.text = "问题反馈"
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
        
        firstSubTitle.snp.makeConstraints { (make) in
            make.top.equalTo((navRect?.height)!+inset.top+16)
            make.left.equalTo(16)
            make.height.equalTo(17)
        }
        firstSubTitle.text = "请描述您遇到的问题"
        firstSubTitle.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.54)
        firstSubTitle.font = UIFont.systemFont(ofSize: 17)
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(firstSubTitle.snp.bottom).offset(8)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(SCREENSIZE.height/3)
        }
        textView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.87)
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        
        inputText.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.top.left.equalTo(16)
            make.bottom.right.equalTo(-16)
        }
        inputText.font = UIFont.systemFont(ofSize: 15)
        inputText.delegate = self
        
        secondSubTitle.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.height.equalTo(17)
        }
        secondSubTitle.text = "留下您的联系方式"
        secondSubTitle.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.54)
        secondSubTitle.font = UIFont.systemFont(ofSize: 17)
        
        secondTextView.snp.makeConstraints { (make) in
            make.top.equalTo(secondSubTitle.snp.bottom).offset(8)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(50)
        }
        secondTextView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.87)
        secondTextView.layer.cornerRadius = 8
        secondTextView.clipsToBounds = true
        
        secondInputText.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.top.left.equalTo(16)
            make.bottom.right.equalTo(-16)
        }
        secondInputText.font = UIFont.systemFont(ofSize: 15)
        secondInputText.delegate = self
        
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(secondTextView.snp.bottom).offset(8)
            make.height.equalTo(10)
        }
        textLabel.text = "*联系方式填写邮箱或微信号均可"
        textLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        textLabel.font = UIFont.systemFont(ofSize: 12)
        
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(textLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(53)
            make.width.equalTo(155)
        }
        confirmButton.setTitle("发送反馈", for: .normal)
        confirmButton.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        confirmButton.layer.cornerRadius = 8
        confirmButton.clipsToBounds = true
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(done))
        endEditView.frame = self.view.frame
        endEditView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0)
        endEditView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.addSubview(endEditView)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        endEditView.removeFromSuperview()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.addSubview(endEditView)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        endEditView.removeFromSuperview()
    }
    
    @objc func done() {
        secondInputText.resignFirstResponder()
    }
    
    @objc func confirm() {
//        self.navigationController?.popViewController(animated: true)
//        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    @objc func back() {
        secondInputText.resignFirstResponder()
//        self.navigationController?.popViewController(animated: true)
//        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        //设置邮件地址、主题及正文
        mailComposeVC.setToRecipients(["<你的邮箱地址>"])
        mailComposeVC.setSubject("<邮件主题>")
        mailComposeVC.setMessageBody("<邮件正文>", isHTML: false)
        
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
    
}
