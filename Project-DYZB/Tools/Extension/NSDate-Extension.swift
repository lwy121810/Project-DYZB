
//
//  NSDate-Extension.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/1.
//  Copyright © 2017年 yons. All rights reserved.
//

import Foundation

extension Date {
    static func getCurrentTime() -> String { // static指的是类方法
   
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
