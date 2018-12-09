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
            let btn = UIButton(frame: CGRect.init(x: (UIScreen.main.bounds.size.width - 50) / 2, y: -14, width: 50, height: 50))
            btn.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            btn.setImage(UIImage.init(named: "add"), for: UIControl.State.normal)
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
    
    let addView = AddView()
    let tableView = UITableView()
    let identifier = "reusedCell"
    
    let SCREENSIZE = UIScreen.main.bounds.size
    var itemNameArray:[String] = ["homeUnselected","mineUnselected"]
    var itemNameSelectArray:[String] = ["homeSelected","mineSelected"]
    var itemTitle:[String] = ["日常","我的"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topLineView.addSubview(dateLabel)
        topLineView.addSubview(calenderDetailButton)
        
        oneSentance.addSubview(editTextButton)
        
        self.view.addSubview(topLineView)
        self.view.addSubview(oneSentance)
        self.view.addSubview(tableView)
        
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
        
        tableView.frame = CGRect(x: 0, y: 140, width: SCREENSIZE.width, height: SCREENSIZE.height-186)
        tableView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        self.configTabBar()
        let addButton = self.tabBarController?.tabBar.AddMyCenterTab()
        addButton?.addTarget(self, action: #selector(add), for: .touchUpInside)
        self.tabBarController?.tabBar.tintColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        self.tabBarController?.tabBar.shadowImage?.draw(in: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
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
        return 95
    }
    
    func getNowTime() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MMM d"
        let strNowTime = timeFormatter.string(from: date) as String
        return strNowTime
    }

    func configTabBar() {
        var count:Int = 0;
        let items = self.tabBarController?.tabBar.items
        for item in items as! [UITabBarItem] {
            let reSize = CGSize(width: 24, height: 24)
            var image:UIImage = UIImage(named: itemNameArray[count])!
            var selectedimage:UIImage = UIImage(named: itemNameSelectArray[count])!
            image = image.reSizeImage(reSize: reSize)
            image = image.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            selectedimage = selectedimage.reSizeImage(reSize: reSize)
            selectedimage = selectedimage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            item.selectedImage = selectedimage
            item.image = image
            item.title = itemTitle[count]
            count = count + 1
        }
        
    }
    @objc func add() {
        self.tabBarController?.view.addSubview(addView)
        addView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(backToHome)))
        addView.isUserInteractionEnabled = true
        addView.addCheckButton.addTarget(self, action: #selector(addCheckTask), for: .touchUpInside)
        addView.addLogButton.addTarget(self, action: #selector(addLog), for: .touchUpInside)
    }
    @objc func backToHome() {
        self.addView.removeFromSuperview()
    }
    @objc func addCheckTask() {
        let addCheckViewController = AddCheckViewController()
        self.navigationController?.pushViewController(addCheckViewController, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.addView.removeFromSuperview()
    }
    @objc func addLog() {
        let addLogViewController = AddLogViewController()
        self.navigationController?.pushViewController(addLogViewController, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.addView.removeFromSuperview()
    }
    @objc func goTo() {
        let logViewController = LogViewController()
        self.navigationController?.pushViewController(logViewController, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
