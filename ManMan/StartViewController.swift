//
//  StartViewController.swift
//  ManMan
//
//  Created by Apple on 2018/12/21.
//  Copyright © 2018年 Mavismwt. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    var backgroundView = UIImageView()
    
    override func viewDidLoad() {
        
        backgroundView.frame = self.view.bounds
        backgroundView.image = UIImage(named: "login")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute:
            {
                let homeViewController = HomeViewController()
                self.navigationController?.pushViewController(homeViewController, animated: false)
        })
        
        self.view.addSubview(backgroundView)
    }
}
