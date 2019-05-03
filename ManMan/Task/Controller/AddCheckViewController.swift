//
//  AddCheckViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/9.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddCheckViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var collectionView:UICollectionView?
    var topLineView = UIView()
    var leftButton = UIButton()
    var rightButton = UIButton()
    var titleView = UILabel()
    var subTitleView = UILabel()
    
    var confirmButton = UIButton()
    let layout = UICollectionViewFlowLayout()
    let inset = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    let SCREENSIZE = UIScreen.main.bounds.size
    
    let imageName = ["fruit","word","drink","breakfast","makeup","sleep","read","sport","medicine"]
    let titleStr:[String] = ["吃水果","背单词","喝水","早餐","化妆","早睡","读书","运动","吃药"]
    var selectedTaskNumber:Int?
    var request = RequestFunction()
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        topLineView.addSubview(leftButton)
        topLineView.addSubview(rightButton)
        topLineView.addSubview(titleView)
        
        self.view.addSubview(topLineView)
        self.view.addSubview(subTitleView)
        self.view.addSubview(confirmButton)
        
        let navRect = self.navigationController?.navigationBar.frame
        topLineView.frame = CGRect(x: 0, y: 0, width: (navRect?.width)!, height: (navRect?.height)!+inset.top)
        topLineView.backgroundColor = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
        
        titleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        titleView.text = "新建日程"
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
        
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(inset.top/2)
            make.right.equalTo(-16)
            make.width.height.equalTo(60)
        }
        rightButton.setTitle("Done", for: .normal)
        rightButton.addTarget(self, action: #selector(backTo), for: .touchUpInside)
        
        layout.itemSize = CGSize(width:(SCREENSIZE.width-24)/3, height: (SCREENSIZE.width-24)/3+20)
        //设置列间距,行间距,偏移 CGRect(x: 0, y: 0, width:(SCREENSIZE.width-24)/3, height: (SCREENSIZE.width-24)/3+20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        subTitleView.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.height.equalTo(17)
        }
        subTitleView.text = "推荐日常"
        subTitleView.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.54)
        subTitleView.font = UIFont.systemFont(ofSize: 17)
        
        collectionView = UICollectionView(frame: CGRect(x: 12, y: 40+(navRect?.height)!+inset.top, width: SCREENSIZE.width-24, height: SCREENSIZE.width+36), collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        let cellFrame = CGRect(x: 0, y: 0, width:(SCREENSIZE.width-24)/3, height: (SCREENSIZE.width-24)/3+20)
        collectionView?.register(CustomizeUICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        self.view.addSubview(collectionView!)

        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView!.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(55)
        }
        confirmButton.layer.cornerRadius = 8
        confirmButton.clipsToBounds = true
        confirmButton.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        confirmButton.setTitle("自定义日常", for: .normal)
        confirmButton.setTitleColor(UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1), for: .normal)
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        confirmButton.layer.shadowColor = UIColor.lightGray.cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 3, height: 6)
        confirmButton.addTarget(self, action: #selector(UserDefined), for: .touchUpInside)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:CustomizeUICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomizeUICollectionViewCell
        let imgName = imageName[indexPath.row]
        let title = titleStr[indexPath.row]
        cell.icon.image = UIImage(named: imgName)
        cell.title.text = title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell:CustomizeUICollectionViewCell = collectionView.cellForItem(at: indexPath) as! CustomizeUICollectionViewCell
        UIView.animate(withDuration: 0.4, animations: {
            cell.cell.backgroundColor = UIColor.init(red: 255/255, green: 213/255, blue: 97/255, alpha: 0.25)
        }, completion: nil)
        selectedTaskNumber = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        var cell:CustomizeUICollectionViewCell = collectionView.cellForItem(at: indexPath) as! CustomizeUICollectionViewCell
        UIView.animate(withDuration: 0.4, animations: {
            cell.cell.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        }, completion: nil)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    @objc func backTo() {
        
        if let number = self.selectedTaskNumber {
            request.postRoutine(title: titleStr[number], icon: imageName[number])
           
        }
        
        let alertView = AlertView()
        UIView.animate(withDuration: 1, animations: {
            self.view.addSubview(alertView)
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute:
            {
                self.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc func UserDefined() {
        let addUserDefinedCheckViewController = AddUserDefinedCheckViewController()
        self.navigationController?.pushViewController(addUserDefinedCheckViewController, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
}
