//
//  BaseAnchorViewController.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/7.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10
private let kGameViewH : CGFloat = 90
let kPrettyCellID = "kPrettyCellID"

private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"
private let kHeaderViewHeaderH : CGFloat = 50

let kNormalItemW = (kScreenW - 3 * kItemMargin) / 2
let kNormalItemH = kNormalItemW * 3 / 4
let kPrettyItemH = kNormalItemW * 4 / 3

private let kCycleViewH = kScreenW * 3 / 8

class BaseAnchorViewController: UIViewController {

    // MARK:- 定义属性
    var baseVM : BaseViewModel!
    
    
    // MARK:- 懒加载collectionView
    /// 懒加载collectionView
    lazy var collectionView : UICollectionView = { [weak self] in
        // 1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        //设置组头
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewHeaderH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        
        /// 2.创建collectionView
        let collectionView = UICollectionView(frame:(self?.view.bounds)! , collectionViewLayout: layout)
        /// 这个时候的view的大小是等于屏幕的宽和高的 需要设置autoresizingMask属性 否则cell的位置会显示不正确
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.white
        /// 注册cell
        collectionView.register(UINib(nibName: "CollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionViewPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        /// 注册
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }

}
extension BaseAnchorViewController {
    func loadData() {
        
    }
}
extension BaseAnchorViewController {
    func setupUI() {
        view.addSubview(collectionView)
    }
}


extension BaseAnchorViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.baseVM.anchorGroups[section].anchors.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.baseVM.anchorGroups.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionViewNormalCell
        let  model  = self.baseVM.anchorGroups[indexPath.section]
        
        cell.anchor = model.anchors[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // 1.取出HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        // 2.给HeaderView设置数据
        headerView.group = baseVM.anchorGroups[indexPath.section]
        
        return headerView
    }
}

