//
//  BaseViewModel.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/7.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit
// MARK:- 父类
class BaseViewModel {
    // MARK:- 数据源
    lazy var anchorGroups : [AnchorGroupModel] = [AnchorGroupModel]()
}
extension BaseViewModel {
    func loadAnchorData(urlString : String, paramters : [String : Any]? = nil, finishCallBack: @escaping ()->()) {
        WYNetworkTool.requestData(type: .GET, urlString: urlString, parameters: paramters) { (result) in
            
            // 1.获取数据
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            // 2.字典转模型
            for dict in dataArray {
                self.anchorGroups.append(AnchorGroupModel(dict: dict))
            }
            
            // 3.完成
            finishCallBack()
        }

    }
}
