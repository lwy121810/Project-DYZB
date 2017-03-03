//
//  RecommendViewModel.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/1.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

class RecommendViewModel {
    // MARK:- 懒加载属性
    fileprivate lazy var anchorGroups : [AnchorGroupModel] = [AnchorGroupModel]()
}

// MARK:- 发送网络请求
extension RecommendViewModel {
    func requestData() {
        // 0.定义参数
        let parameters = ["limit": "4", "offset":"8","time":Date.getCurrentTime()]
        
        // 1.请求第一部分的数据 - 推荐数据
        let recommendUrlString = "http://capi.douyucdn.cn/api/v1/getbigDataRoom"
        let recommendParam = ["time":Date.getCurrentTime()]
        WYNetworkTool.requestData(type: .GET, urlString: recommendUrlString, parameters: recommendParam) { (result) in
            // 1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.取出data数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历数组 转成模型
            // 3.1 创建组
            let group = AnchorGroupModel()
            // 3.2 设置组的属性
            group.tag_name = "热门"
            group.icon_name = "home_header_hot"
            
            // 3.3.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict:dict)
                group.anchors.append(anchor)
            }

        }
        
        
        // 2.请求第二部分的数据 - 颜值数据
        let prettyUrlString = "http://capi.douyucdn.cn/api/v1/getVerticalRoom"
        WYNetworkTool.requestData(type: .GET, urlString: prettyUrlString, parameters: parameters) { (result) in
            // 1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.取出data数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历数组 转成模型
            // 3.1 创建组
            let group = AnchorGroupModel()
            // 3.2 设置组的属性
            group.tag_name = "颜值"
            group.icon_name = "home_header_phone"
            
            // 3.3.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict:dict)
                group.anchors.append(anchor)
            }
        }
        
        let otherUrlString = "http://capi.douyucdn.cn/api/v1/getHotCate"
        // 2. 请求2-12部分的数据
        WYNetworkTool.requestData(type: .GET, urlString: otherUrlString, parameters: parameters) { (result) in
            // 1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.取出data数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历数组 获取字典 并转成模型对象
            
            for dict in dataArray {
                let group = AnchorGroupModel(dict: dict)
                self.anchorGroups.append(group)
            }
            
            
            for group in self.anchorGroups {
                for anchor in group.anchors {
                    WYLog(anchor.nickname)
                }
            }
            
        }
        
    }
}
