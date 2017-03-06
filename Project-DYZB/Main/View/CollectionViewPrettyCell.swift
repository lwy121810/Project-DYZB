//
//  CollectionViewPrettyCell.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/1.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit
import Kingfisher
/// 颜值部分的cell
class CollectionViewPrettyCell: CollectionBaseCell {
    @IBOutlet weak var cityButton: UIButton!

    /// 定义模型属性 因为父类已经有这个属性 子类要想重写父类的属性需要加override
    override var anchor : AnchorModel? {
        didSet {
            // 1.将模型数据传递给父类
            super.anchor = anchor
            // 2.所在的城市
            cityButton.setTitle(anchor?.anchor_city, for: .normal)
            
        }
    }
}
