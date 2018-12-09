//
//  HomeViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/6.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage;
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width:self.size.width * scaleSize, height:self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}

extension UITabBar
{
    
    //关联对象的ID,注意，在私有嵌套 struct 中使用 static var，这样会生成我们所需的关联对象键，但不会污染整个命名空间。
    
    private struct AssociatedKeys {
        static var TabKey = "tabView"
    }
    
    //定义一个新的tabbar属性,并设置set,get方法
    var btnTab:UIButton?{
        
        get{
            //通过Key获取已存在的对象
            return objc_getAssociatedObject(self, &AssociatedKeys.TabKey) as? UIButton
            
        }
        
        set{
            //对象不存在则创建
            objc_setAssociatedObject(self, &AssociatedKeys.TabKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     添加中心按钮
     */
    func AddMyCenterTab()->UIButton
    {
        if self.btnTab == nil
        {
            
            self.shadowImage = UIImage()//(49 - 42) / 2
            let btn = UIButton(frame: CGRect.init(x: (WIDTH - 50) / 2, y: -14, width: 50, height: 50))
            
            btn.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
            btn.setImage(UIImage.init(named: "工具"), forState: UIControlState.Normal)
            self.addSubview(btn)
            self.btnTab = btn
            
            
            
        }
        
        
        return self.btnTab!
    }
    
    
}


class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   
    
    var topLineView = UIView()
    var calenderDetailButton = UIButton()
    var dateLabel = UILabel()
    var oneSentance = UITextField()
    var editTextButton = UIImageView()
    var addButton = UIButton()
    
    let tableView = UITableView()
    let identifier = "reusedCell"
    
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topLineView.addSubview(dateLabel)
        topLineView.addSubview(calenderDetailButton)
        
        oneSentance.addSubview(editTextButton)
        
        self.view.addSubview(topLineView)
        self.view.addSubview(oneSentance)
        self.view.addSubview(tableView)
        self.view.addSubview(addButton)
        
        topLineView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(SCREENSIZE.width)
            make.height.equalTo(70)
        }
        topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        calenderDetailButton.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(topLineView.snp.centerY).offset(10)
            make.width.height.equalTo(24)
        }
        calenderDetailButton.setImage(UIImage(named: "calenderIcon"), for: .normal)
        calenderDetailButton.addTarget(self, action: #selector(goTo), for: .touchUpInside)
        
        
        dateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(topLineView.snp.right).offset(40)
            make.centerY.equalTo(topLineView.snp.centerY).offset(10)
            make.height.equalTo(18)
            make.width.equalTo(120)
        }
        dateLabel.text = getNowTime()
        dateLabel.textColor = UIColor.white
        dateLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        oneSentance.snp.makeConstraints { (make) in
            make.top.equalTo(86)
            make.left.equalTo(16)
            make.right.equalTo(self.view.snp.right).offset(-16)
            make.height.equalTo(50)
        }
        oneSentance.layer.cornerRadius = 8
        oneSentance.clipsToBounds = true
        oneSentance.placeholder = "   一句话..."
        oneSentance.backgroundColor = UIColor.white
        
        editTextButton.snp.makeConstraints { (make) in
            make.right.equalTo(oneSentance.snp.right).offset(-16)
            make.centerY.equalTo(oneSentance.snp.centerY)
            make.width.height.equalTo(16)
        }
        editTextButton.image = UIImage(named: "edit")
        
        tableView.frame = CGRect(x: 0, y: 136, width: SCREENSIZE.width, height: SCREENSIZE.height-136)
        tableView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        addButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-7)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.height.equalTo(34)
        }
        addButton.addTarget(self, action: #selector(goTo), for: .touchUpInside)
        addButton.backgroundColor = UIColor.orange
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0)
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        

        let reSize = CGSize(width: 20, height: 20)
        var homeSelected = UIImage(named: "homeSelected")
        homeSelected = homeSelected?.reSizeImage(reSize: reSize)
        var homeUnselected = UIImage(named: "homeUnselected")
        homeUnselected = homeUnselected?.reSizeImage(reSize: reSize)
        self.tabBarItem = UITabBarItem(title: "日常", image: homeUnselected?.withRenderingMode(.alwaysOriginal) , selectedImage: homeSelected?.withRenderingMode(.alwaysOriginal))
        self.tabBarController?.tabBar.tintColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:CheckCardCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? CheckCardCell
        if (cell == nil)
        {
            cell = CheckCardCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }
        //self.viewDidDisappear(true)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    
    func getNowTime() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MMM d"
        let strNowTime = timeFormatter.string(from: date) as String
        return strNowTime
    }
    
    @objc func goTo() {
        let flagViewController = FlagViewController()
        self.navigationController?.pushViewController(flagViewController, animated: true)
    }
}
