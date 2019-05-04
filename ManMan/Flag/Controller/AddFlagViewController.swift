//
//  AddFlagViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/15.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddFlagViewController: UIViewController ,UITextViewDelegate {
    
    var topLineView = UIView()
    var leftButton = UIButton()
    var titleView = UILabel()
    var textView = UIView()
    var inputText = UITextView()
    var confirmButton = UIButton()
    
    var request = RequestFunction()
    
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(leftButton)
        topLineView.addSubview(titleView)
        textView.addSubview(inputText)
        
        self.view.addSubview(textView)
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
        titleView.text = "设定我的FLAG"
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
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo((navRect?.height)!+inset.top+16)
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
        //inputText.isEditable = true
        inputText.delegate = self
        
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(53)
            make.width.equalTo(155)
        }
        confirmButton.setTitle("发送FLAG", for: .normal)
        confirmButton.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        confirmButton.layer.cornerRadius = 8
        confirmButton.clipsToBounds = true
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location >= 100{
            return false
        }
        return true
    }
    
    @objc func confirm() {
        let alertView = AlertView()
//        if let flagID = UserDefaults.standard.value(forKey: "myFlagID") {
//            let flagid = flagID as! String
//            request.putFlag(id: flagid, content: "test")
//        } else {
            request.postFlag(content: inputText.text)
//        }
    
        UIView.animate(withDuration: 1, animations: {
            self.view.addSubview(alertView)
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute:
            {
                self.navigationController?.popViewController(animated: true)
        })
         UserDefaults.standard.set(self.inputText.text, forKey: "flagDetail")
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
