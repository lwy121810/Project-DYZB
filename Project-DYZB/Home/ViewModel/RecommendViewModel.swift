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
    lazy var anchorGroups : [AnchorGroupModel] = [AnchorGroupModel]()
    // MARK:- 懒加载属性
    lazy var cycleModels : [CycleModel] = [CycleModel]()
    
    /// 推荐部分的数据
    fileprivate lazy var recommendDataGroup : AnchorGroupModel = AnchorGroupModel()
    /// 颜值部分的数据
    fileprivate lazy var prettyDataGroup : AnchorGroupModel  = AnchorGroupModel()
    
    
}

// MARK:- 发送网络请求
extension RecommendViewModel {
    // 请求推荐数据
    func requestData(_ finishCallBack : @escaping ()->()) {
        // 0.定义参数
        let parameters = ["limit": "4", "offset":"8","time":Date.getCurrentTime()]
        
        // 1.创建队列组
        let disGroup = DispatchGroup()
        
        // 2.请求第一部分的数据 - 推荐数据
        disGroup.enter()//加入组
        let recommendUrlString = "http://capi.douyucdn.cn/api/v1/getbigDataRoom"
        let recommendParam = ["time":Date.getCurrentTime()]
        WYNetworkTool.requestData(type: .GET, urlString: recommendUrlString, parameters: recommendParam) { (result) in
            // 1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.取出data数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历数组 转成模型
            // 3.1 设置组的属性
            self.recommendDataGroup.tag_name = "热门"
            self.recommendDataGroup.icon_name = "home_header_hot"
            
            // 3.3.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict:dict)
                self.recommendDataGroup.anchors.append(anchor)
            }
            
            // 3.4.离开组
            disGroup.leave()
        }
        
        
        // 3.请求第二部分的数据 - 颜值数据
        disGroup.enter()//添加进组
        let prettyUrlString = "http://capi.douyucdn.cn/api/v1/getVerticalRoom"
        WYNetworkTool.requestData(type: .GET, urlString: prettyUrlString, parameters: parameters) { (result) in
            // 1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.取出data数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历数组 转成模型
            // 3.1 设置组的属性
            self.prettyDataGroup.tag_name = "颜值"
            self.prettyDataGroup.icon_name = "home_header_phone"
            
            // 3.3.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict:dict)
                self.prettyDataGroup.anchors.append(anchor)
            }
            disGroup.leave()//离开组
        }
        
        let otherUrlString = "http://capi.douyucdn.cn/api/v1/getHotCate"
        // 4. 请求2-12部分的数据
        disGroup.enter()//添加进组
        WYNetworkTool.requestData(type: .GET, urlString: otherUrlString, parameters: parameters) { (result) in
            // 1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.取出data数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历数组 获取字典 并转成模型对象
            
            for dict in dataArray {
                //转成模型
                let group = AnchorGroupModel(dict: dict)
                //添加到数组中
                self.anchorGroups.append(group)
            }
            disGroup.leave()//离开组
        }
        
        // 5.所有请求的数据都请求到之后，对数据进行排序
        disGroup.notify(queue: DispatchQueue.main) { 
            self.anchorGroups.insert(self.prettyDataGroup, at: 0)
            self.anchorGroups.insert(self.recommendDataGroup, at: 0)
            
            finishCallBack()
        }
        
        
    }
    
    // 请求无限轮播数据
    func requestCycleData(_ finishCallBack : @escaping ()->()) {
        let param =  ["version" : "2.300"];
        let urlString = "http://www.douyutv.com/api/v1/slide/6"
        WYNetworkTool.requestData(type: .GET, urlString: urlString, parameters: param) { (result) in
            // 1.获取整体字典数据
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.根据data的key获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.字典转模型对象
            for dict in dataArray {
                self.cycleModels.append(CycleModel(dict: dict))
            }
            
            finishCallBack()
        }
        
    }
    
    
}
