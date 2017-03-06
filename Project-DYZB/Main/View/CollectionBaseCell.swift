//
//  CollectionBaseCell.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/6.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

class CollectionBaseCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var onlineButton: UIButton!
    
    /// 定义模型属性
    var anchor : AnchorModel? {
        didSet {
            // 0.校验模型是否有值
            guard let anchor = anchor else { return }
            
            // 1.取出在线人数
            var onlineStr : String = ""
            if anchor.online >= 10000 {
                onlineStr = "\(Int(anchor.online / 10000))万在线"
            } else {
                onlineStr = "\(anchor.online)在线"
            }
            
            onlineButton.setTitle(onlineStr, for: .normal)
            
            // 2.显示昵称
            nickNameLabel.text = anchor.nickname
            
            // 4.设置图片
            guard  let iconUrl = URL(string: anchor.vertical_src) else { return }
            
            iconImageView.kf.setImage(with: iconUrl)
            
        }
    }
}
