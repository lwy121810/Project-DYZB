//
//  CollectionHeaderView.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/2/28.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    

    var group : AnchorGroupModel? {
        didSet {
            self.titleLabel.text = group?.tag_name
            self.iconView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
        }
    }
    
}
