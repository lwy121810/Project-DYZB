//
//  AmuseViewController.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/7.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit


/// 娱乐页面
class AmuseViewController: BaseAnchorViewController {

    // MARK:- 懒加载属性
    lazy var amuseVM : AmuseViewModel = AmuseViewModel()
}
// MARK:- 请求数据 重写父类方法
extension AmuseViewController {
    override func loadData() {
        //给父类的vm赋值
        baseVM = amuseVM
        //请求数据
        self.amuseVM.loadAmuseData { 
            self.collectionView.reloadData()
        }
    }
}

//extension AmuseViewController {
//    override func setupUI() {
//        super.setupUI()
//    }
//}
