//
//  LogInViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/21.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var backgroundView = UIImageView()
    
    override func viewDidLoad() {
        
        backgroundView.frame = self.view.bounds
        backgroundView.image = UIImage(named: "login")
        
        self.view.addSubview(backgroundView)
    }
}
