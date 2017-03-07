//
//  RecommendGameCell.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/7.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit
import Kingfisher

class RecommendGameCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK:- 定义数据模型的属性
    var baseGame : BaseGameModel? {
        didSet {
            titleLabel.text = baseGame?.tag_name
            
            if let iconURL = URL(string: baseGame?.icon_url ?? "") {
                iconImageView.kf.setImage(with: iconURL)
            } else {
                iconImageView.image = UIImage(named: "home_more_btn")
            }

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
}
extension RecommendGameCell {
    fileprivate func setupView() {
        self.iconImageView.isUserInteractionEnabled = true
        self.iconImageView.clipsToBounds = true
        self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.width * 0.5
    }
}
