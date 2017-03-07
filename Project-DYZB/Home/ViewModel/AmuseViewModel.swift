//
//  AmuseViewModel.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/7.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

class AmuseViewModel: BaseViewModel {

}
extension AmuseViewModel {
    func loadAmuseData(finishCallBack : @escaping ()->()) {
        
        let urlString = "http://capi.douyucdn.cn/api/v1/getHotRoom/2"
        loadAnchorData(urlString: urlString, finishCallBack: finishCallBack)
    }
}
