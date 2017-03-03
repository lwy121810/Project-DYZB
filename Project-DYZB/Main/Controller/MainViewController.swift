//
//  MainViewController.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/2/27.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let childVc = UIViewController()
//        childVc.view.backgroundColor = UIColor.red
//        addChildViewController(childVc)
        
        addChildVcWithStoryboardName(name: "Home")
        addChildVcWithStoryboardName(name: "Live")
        addChildVcWithStoryboardName(name:"Follow")
        addChildVcWithStoryboardName(name: "Profile")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MainViewController {
   fileprivate func addChildVcWithStoryboardName(name : String) {
        let childVc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        addChildViewController(childVc)
    }
}
