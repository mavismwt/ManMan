//
//  CView.swift
//  ManMan
//
//  Created by Apple on 2018/12/16.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    let screenW = UIScreen.main.bounds.width
    
    fileprivate lazy var calendar : FSCalendar = {
        //获取FSCalendar的实例
        let calendar = FSCalendar.init(frame: CGRect.init(x: 0, y: 0, width: screenW, height: screenW))
        //设置FSCalendar的dataSource和delegate
        calendar.dataSource = self
        calendar.delegate = self
        return calendar
        
    }()
    
    override func viewDidLoad() {
        self.view.addSubview(calendar)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

