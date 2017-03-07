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
    
    @IBOutlet weak var moreButton: UIButton!

    var group : AnchorGroupModel? {
        didSet {
            self.titleLabel.text = group?.tag_name
            self.iconView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
        }
    }
    
}
// MARK:- 从Xib中快速创建的类方法
extension CollectionHeaderView {
    class func collectionHeaderView() -> CollectionHeaderView {
        return Bundle.main.loadNibNamed("CollectionHeaderView", owner: nil, options: nil)?.first as! CollectionHeaderView
    }
}
