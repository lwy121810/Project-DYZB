//
//  GameViewModel.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/7.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

class GameViewModel {
    lazy var gameModelArray :[GameModel] = [GameModel]()
}

extension GameViewModel {
    func loadAllGameData(finishCallBack : @escaping ()->()) {
        let urlString = "http://capi.douyucdn.cn/api/v1/getColumnDetail"
        let param = ["shortName" : "game"]
        WYNetworkTool.requestData(type: .GET, urlString: urlString, parameters: param) { (result) in
            // 1.获取数据
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            // 2.字典转模型
            for dict in dataArray {
                let model = GameModel(dict: dict)
                self.gameModelArray.append(model)
            }
            
            // 3.完成
            
            finishCallBack()
        }
    }
}
