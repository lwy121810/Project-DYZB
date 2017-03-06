//
//  CollectionViewNormalCell.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/2/28.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

class CollectionViewNormalCell: CollectionBaseCell {
    @IBOutlet weak var roomNameLabel: UILabel!

    
    override var anchor : AnchorModel? {
        didSet {
            // 1.将属性传递给父类
            super.anchor = anchor
            // 4.房间名字
            roomNameLabel.text = anchor?.room_name
        }
    }
    

}
