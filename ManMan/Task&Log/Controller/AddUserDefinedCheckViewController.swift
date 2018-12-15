//
//  UserDefinedAddCheckViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class AddUserDefinedCheckViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    
    var collectionView:UICollectionView?
    var topLineView = UIView()
    var leftButton = UIButton()
    var titleView = UILabel()
    var cardTitleView = UILabel()
    var cardView = UIView()
    var backgroudImage = UIImageView()
    var editButton = UIButton()
    var taskIcon = UIImageView()
    var taskName = UILabel()
    var taskProcess = UILabel()
    var subTitleView = UILabel()
    var confirmButton = UIButton()
    
    let layout = UICollectionViewFlowLayout()
    let SCREENSIZE = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(leftButton)
        topLineView.addSubview(titleView)
        
        cardView.addSubview(backgroudImage)
        cardView.addSubview(taskIcon)
        cardView.addSubview(taskName)
        cardView.addSubview(editButton)
        cardView.addSubview(taskProcess)
        
        self.view.addSubview(cardTitleView)
        self.view.addSubview(subTitleView)
        self.view.addSubview(confirmButton)
        self.view.addSubview(cardView)
        self.view.addSubview(topLineView)
        
        
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
        titleView.text = "新建日程"
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
        
        layout.itemSize = CGSize(width:(SCREENSIZE.width-12)/3, height: (SCREENSIZE.width-12)/3)
        //设置列间距,行间距,偏移 CGRect(x: 0, y: 0, width:(SCREENSIZE.width-24)/3, height: (SCREENSIZE.width-24)/3+20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        cardTitleView.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.height.equalTo(17)
        }
        cardTitleView.text = "图标预览"
        cardTitleView.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.54)
        cardTitleView.font = UIFont.systemFont(ofSize: 17)
        
        cardView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(cardTitleView.snp.bottom).offset(10)
            make.height.equalTo(87)
        }
        cardView.layer.cornerRadius = 12
        cardView.clipsToBounds = true
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 3, height: 6)
        
        backgroudImage.snp.makeConstraints { (make) in
            make.top.left.width.height.equalToSuperview()
        }
        backgroudImage.image = UIImage(named: "checked")
        backgroudImage.layer.cornerRadius = 12
        backgroudImage.clipsToBounds = true
        
        taskIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(cardView.snp.centerY)
            make.left.equalTo(16)
            make.width.height.equalTo(56)
        }
        taskIcon.image = UIImage(named: "dateSelected")
        
        taskName.snp.makeConstraints { (make) in
            make.top.equalTo(26)
            make.left.equalTo(88)
            make.height.equalTo(17)
        }
        taskName.text = "喝水"
        taskName.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.87)
        taskName.font = UIFont.boldSystemFont(ofSize: 17)
        
        editButton.snp.makeConstraints { (make) in
            make.left.equalTo(taskName.snp.right).offset(8)
            make.centerY.equalTo(taskName.snp.centerY)
            make.width.height.equalTo(15)
        }
        editButton.setImage(UIImage(named: "edit"), for: .normal)
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        
        taskProcess.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.left.equalTo(88)
            make.height.equalTo(12)
        }
        taskProcess.text = "已完成10天"
        taskProcess.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.54)
        taskProcess.font = UIFont.systemFont(ofSize: 12)
        
        
        subTitleView.snp.makeConstraints { (make) in
            make.top.equalTo(cardTitleView.snp.bottom).offset(116)
            make.left.equalTo(16)
            make.height.equalTo(17)
        }
        subTitleView.text = "自定义图标"
        subTitleView.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.54)
        subTitleView.font = UIFont.systemFont(ofSize: 17)
        
        collectionView = UICollectionView(frame: CGRect(x: 6, y: 242, width: SCREENSIZE.width-12, height: SCREENSIZE.width-12), collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(FangCustomizeUICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        self.view.addSubview(collectionView!)
        
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView!.snp.bottom).offset(16)
            make.left.equalTo(88)
            make.right.equalTo(-88)
            make.height.equalTo(55)
        }
        confirmButton.layer.cornerRadius = 8
        confirmButton.clipsToBounds = true
        confirmButton.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        confirmButton.setTitle("保存自定义日常", for: .normal)
        confirmButton.setTitleColor(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        confirmButton.layer.shadowColor = UIColor.lightGray.cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 3, height: 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    @objc func edit() {
        
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

