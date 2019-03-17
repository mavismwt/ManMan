//
//  ViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/5.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var boxView :UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.boxView.backgroundColor = UIColor.orange
        
        self.view.addSubview(self.boxView)
        
        self.boxView.snp.makeConstraints{ (make) in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.center.equalTo(self.view)
        }
    }


}

