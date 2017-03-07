//
//  AnchorGroupModel.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/2.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit
// MARK:- 主播组model
class AnchorGroupModel: BaseGameModel {
    /// 该组中对应的房间信息
    var room_list : [[String : NSObject]]? {
        didSet { // 监听属性的变化 跟下面的setValue(_ value: Any?, forKey key: String)方法作用一致
            guard let room_list = room_list else { return } //先验证是否有值
            for dict in room_list {
                let anchor = AnchorModel(dict: dict)
                anchors.append(anchor)
            }
        }
    }
    
    /// 组显示的图标
    var icon_name : String = "home_header_normal"
    /// 定义主播的模型对象数组 包含的是主播model
    lazy var anchors : [AnchorModel] = [AnchorModel]()
    /// 把room_list的数据转成主播模型
    /*
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "room_list" {
            if let dataArray = value as? [[String : NSObject]] {
                for dict in dataArray {
                    let anchor = AnchorModel(dict: dict)
                    anchors.append(anchor)
                }
            }
        }
    }
    */
}
