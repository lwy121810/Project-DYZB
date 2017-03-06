//
//  WYCycleCell.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/6.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit
import Kingfisher

class WYCycleCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
   // MARK:- 定义模型属性
    var cycleModel : CycleModel? {
        didSet {
            titleLabel.text = cycleModel?.title
            let iconURL = URL(string: cycleModel?.pic_url ?? "")!
            iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: "Img_default"))
        }
    }
    

}
