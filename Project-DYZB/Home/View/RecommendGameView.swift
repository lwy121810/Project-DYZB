//
//  RecommendGameView.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/7.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

private let kGameCellID = "kGameCellID"
private let kEdgeInsetMargin : CGFloat = 10
class RecommendGameView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var groups : [BaseGameModel]? {
        didSet {
            
            // 1.刷新列表
            self.collectionView.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 让控件不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
        setupView()
    }
}

extension RecommendGameView {
    fileprivate func setupView() {
        collectionView.dataSource = self
        // 注册Cell
        collectionView.register(UINib(nibName: "RecommendGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 80, height: 90)
        
    }
}

extension RecommendGameView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! RecommendGameCell
        let group = groups?[indexPath.item]
        cell.baseGame = group

        return cell
    }
}

// MARK:- 快速创建的类方法
extension RecommendGameView {
    class func recommendGameView() -> RecommendGameView {
        return Bundle.main.loadNibNamed("RecommendGameView", owner: nil, options: nil)?.first as! RecommendGameView
    }
}
